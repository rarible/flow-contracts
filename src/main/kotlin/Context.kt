import org.onflow.sdk.*
import org.onflow.sdk.crypto.Crypto
import org.onflow.sdk.crypto.KeyPair
import org.onflow.sdk.crypto.PublicKey
import java.io.File

class Context(val config: Config) {

    data class Account(
        val name: String,
        val address: FlowAddress,
        val keyPair: KeyPair,
        val account: FlowAccount,
    )

    val api: FlowAccessApi = Flow.newAccessApi(config.connect.host, config.connect.port)
    val latestBlockId: FlowId = api.getLatestBlockHeader().id
    val serviceAccount: Account
    val accounts: List<Account>
    val accountAliases: Map<String, Account>
    val aliasAddressMapping: Map<String, String>

    init {
        val configServiceAccount = config.accounts.find { it.name == config.connect.serviceAccountName }!!
        serviceAccount = loadAccount(configServiceAccount)
        println("service account: ${serviceAccount.address.formatted}")
        accounts = config.accounts.map { loadOrCreateAccount(it) }
        accounts.forEach { println(" > [${it.address.formatted}] ${it.name}") }
        accountAliases = accounts.associateBy(Account::name)
        aliasAddressMapping = config.aliasAddressMapping + config.scheme.flatMap { (account, names) ->
            names.map {
                val contract = config.contractAliases[it] ?: throw IllegalStateException("Not found contract by $it")
                val account1 = accountAliases[account] ?: throw IllegalStateException("Not found account by $it")
                contract.alias to account1.address.formatted
            }
        }.toMap()
    }

    fun replaceImports(script: String): String =
        config.contractDepsRe.replace(script) {
            aliasAddressMapping[it.value] ?: throw IllegalStateException("Not found address for alias: ${it.value}")
        }

    fun fromProject(name: String) =
        replaceImports(File(config.projectPath, name).readText())

    fun getAccount(address: FlowAddress) = api.getAccountAtLatestBlock(address)!!

    fun signer(account: Account) = Crypto.getSigner(account.keyPair.private)

    fun loadAccount(acc: Config.Account): Account {
        val keyPair = KeyPair(Crypto.decodePrivateKey(acc.privateKey!!), Crypto.decodePublicKey(acc.publicKey!!))
        val account = api.getAccountAtLatestBlock(FlowAddress(acc.address!!))!!
        return Account(acc.name, account.address, keyPair, account)
    }

    fun createAccount(publicKey: PublicKey): FlowAddress {
        val (_, result) = sendTx(serviceAccount, config.fromResource("create_account.cdc")) {
            val x = FlowAccountKey(
                publicKey = FlowPublicKey(publicKey.hex),
                signAlgo = SignatureAlgorithm.ECDSA_P256,
                hashAlgo = HashAlgorithm.SHA3_256,
                weight = 1000
            )
            arg { string(x.encoded.bytesToHex()) }
        }
        return FlowAddress(createdAccountAddress(result))
    }

    fun createAccountAndLoad(account: Config.Account): Account {
        val keyPair = Crypto.generateKeyPair()
        val flowAccount = getAccount(createAccount(keyPair.public))
        return Account(account.name, flowAccount.address, keyPair, flowAccount)
    }

    fun loadOrCreateAccount(account: Config.Account) =
        if (account.address == null) createAccountAndLoad(account) else loadAccount(account)

    fun sendTx(
        account: Account,
        source: String,
        argBuilder: FlowArgumentsBuilder.() -> Unit
    ): Pair<FlowId, FlowTransactionResult> =
        api.simpleFlowTransaction(account.address, signer(account)) {
            script(source)
            arguments.addAll(FlowArgumentsBuilder().apply(argBuilder).build())
        }.sendAndGetResult()

    private fun createdAccountAddress(result: FlowTransactionResult) = result.events
        .find { it.type == "flow.AccountCreated" }!!
        .event.value!!.fields[0].value.value as String

    fun deployContract(account: Account, contract: Config.Contract): FlowEvent {
        val source = config.fromResource(
            if (contract.name in account.account.contracts.keys) "contract_update.cdc" else "contract_add.cdc"
        )
        val (txId, result) = sendTx(account, source) {
            arg { string(contract.name) }
            arg { byteArray(fromProject(contract.source).toByteArray()) }
        }
        println(txId.base16Value)
        return result.events.first()
    }
}

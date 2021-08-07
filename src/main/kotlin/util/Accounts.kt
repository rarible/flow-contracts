package util

import org.onflow.sdk.*
import org.onflow.sdk.crypto.Crypto
import org.onflow.sdk.crypto.KeyPair
import org.onflow.sdk.crypto.PublicKey

class Accounts(private val api: FlowAccessApi, load: List<AccountDef>, create: List<String>) {

    companion object {
        const val serviceAccountName = "service"
    }

    data class AccountDef(
        val name: String,
        val addressHex: String,
        val publicKey: String,
        val privateKey: String,
    )

    val accounts: Map<String, Account>
    val byAddress: Map<String, Account>
    val serviceAccount: Account

    init {
        val loaded = load.map { loadAccount(it) }.associateBy { it.name }
        serviceAccount = loaded[serviceAccountName] ?: throw IllegalStateException("Not found service account")
        val created = create.map { createAndLoadAccount(it) }.associateBy { it.name }
        accounts = loaded + created
        byAddress = accounts.values.associateBy { it.address.formatted }
    }

    operator fun get(key: String) = accounts[key]

    fun fromResource(name: String) =
        javaClass.classLoader.getResourceAsStream(name)!!
            .use { it.bufferedReader().readText() }

    fun getAccount(addressHex: String) =
        getAccount(FlowAddress(addressHex))

    fun getAccount(address: FlowAddress) =
        api.getAccountAtLatestBlock(address)

    fun loadAccount(acc: AccountDef): Account {
        val keyPair = KeyPair(Crypto.decodePrivateKey(acc.privateKey), Crypto.decodePublicKey(acc.publicKey))
        val account = api.getAccountAtLatestBlock(FlowAddress(acc.addressHex))!!
        return Account(acc.name, keyPair, account)
    }

    fun createAndLoadAccount(name: String): Account {
        val keyPair = Crypto.generateKeyPair()
        val flowAccount = getAccount(createAccount(keyPair.public))!!
        return Account(name, keyPair, flowAccount)
    }

    fun createAccount(publicKey: PublicKey): FlowAddress {
        val (_, result) = sendTx(serviceAccount, fromResource("create_account.cdc")) {
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

    fun signer(account: Account) = Crypto.getSigner(account.keyPair.private)

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

}

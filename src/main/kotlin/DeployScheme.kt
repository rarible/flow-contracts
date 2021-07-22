import org.onflow.sdk.*
import org.onflow.sdk.crypto.Crypto

class DeployScheme(val api: FlowAccessApi, val contracts: Contracts, val accounts: Accounts) {
    fun deploy() {
        contracts.contractsForDeploy().map { contract ->
            val account = accounts.byAddress[contract.address]!!
            deployContract(account, contract.name, contract.source)
        }
    }

    fun deployContract(account: Accounts.Account, contractName: String, contractSource: String): FlowEvent {
        val source = fromResource(
            if (contractName in account.account.contracts.keys) "contract_update.cdc" else "contract_add.cdc"
        )
        val (txId, result) = sendTx(account, source) {
            arg { string(contractName) }
            arg { byteArray(contractSource.toByteArray()) }
        }
        println(txId.base16Value)
        return result.events.first()
    }

    fun fromResource(name: String) =
        javaClass.classLoader.getResourceAsStream(name)!!
            .use { it.bufferedReader().readText() }

    fun signer(account: Accounts.Account) = Crypto.getSigner(account.keyPair.private)

    fun sendTx(
        account: Accounts.Account,
        source: String,
        argBuilder: FlowArgumentsBuilder.() -> Unit
    ): Pair<FlowId, FlowTransactionResult> =
        api.simpleFlowTransaction(account.address, signer(account)) {
            script(source)
            arguments.addAll(FlowArgumentsBuilder().apply(argBuilder).build())
        }.sendAndGetResult()

}

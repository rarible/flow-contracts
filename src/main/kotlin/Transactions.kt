import org.onflow.sdk.*
import org.onflow.sdk.crypto.Crypto
import java.io.File

class Transactions(val api: FlowAccessApi, val cadenceRoot: String, val aliasMapping: Map<String, String>) {
    companion object {
        private val importRe = Regex("0x\\w+")
    }

    fun signer(account: Accounts.Account) = Crypto.getSigner(account.keyPair.private)

    fun transactionTextRaw(name: String) = File("${cadenceRoot}/transactions/${name}").readText()

    fun transactionText(name: String) = replaceImports(transactionTextRaw(name))

    fun replaceImports(script: String): String =
        importRe.replace(script) {
            aliasMapping[it.value] ?: throw IllegalStateException("Not found address for alias: ${it.value}")
        }

    fun transaction(
        account: Accounts.Account,
        name: String,
        argBuilder: FlowArgumentsBuilder.() -> Unit = {}
    ): Pair<FlowId, FlowTransactionResult> =
        api.simpleFlowTransaction(account.address, signer(account)) {
            script(transactionText(name))
            arguments.addAll(FlowArgumentsBuilder().apply(argBuilder).build())
        }.sendAndGetResult()

    fun initHolder(account: Accounts.Account) =
        transaction(account, "nftProvider/init_holder.cdc")

    fun mintNftPublic(account: Accounts.Account, link: String) =
        transaction(account, "nftProvider/mint_nft_public.cdc") {
            arg { optional { null } }
            arg { string(link) }
        }

    fun mintNftToAddress(account: Accounts.Account, address: String, link: String) =
        transaction(account, "nftProvider/mint_nft_to_address.cdc") {
            arg { address(address) }
            arg { optional { null } }
            arg { string(link) }
        }

    fun transferNft(account: Accounts.Account, tokenId: ULong, address: String) =
        transaction(account, "nftProvider/transfer_nft.cdc") {
            arg { uint64(tokenId) }
            arg { address(address) }
        }
}

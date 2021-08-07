import contracts.CommonNFT
import contracts.FlowToken
import contracts.StoreShowCase
import util.*

class TestnetApp {
    companion object {
        @JvmStatic
        fun main(args: Array<String>) {
            val api = Testnet.api()
            val accounts = Accounts(api, listOf(Testnet.serviceAccount), emptyList())
            val contracts = Contracts(
                "cadence",
                "contracts",
                Testnet.coreContracts,
                mapOf(Testnet.serviceAccount.addressHex to Config.contractsToDeploy)
                    .flatMap { (address, contracts) -> contracts.map { it to address } }
                    .toMap()
            )
            val deployScheme = DeployScheme(api, contracts, accounts)
            deployScheme.deploy()

            val service = accounts.serviceAccount
            val converter = SourceConverter(Testnet.coreContracts + contracts.deployAddresses)
            val flowToken = FlowToken(api, converter)
            val commonNFT = CommonNFT(api, converter)
            val showCase = StoreShowCase(api, converter)

            val royalties = mapOf(service.addressHex to 2.0)
            val tokenId = commonNFT.mint(service, "ipfs://metadata", royalties)
                .uLongValue("CommonNFT.Mint", "id")!!
            commonNFT.borrowNft(service.addressHex, tokenId)
            commonNFT.burn(service, tokenId)
        }
    }
}

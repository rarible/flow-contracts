import contracts.CommonNFT
import contracts.FlowToken
import contracts.StoreShowCase
import org.onflow.sdk.Flow

class TestnetApp {
    companion object {
        private val coreContracts = mapOf(
            "FlowFees" to "0x912d5440f7e3769e",
            "FlowToken" to "0x7e60df042a9c0868",
            "FungibleToken" to "0x9a0766d93b6608b7",
            "NonFungibleToken" to "0x631e88ae7f1d7c20",
            "FUSD" to "0xe223d8a629e49c68"
        )

        @JvmStatic
        fun main(args: Array<String>) {
            val api = Flow.newAccessApi("access.devnet.nodes.onflow.org", 9000)
            val existingAccounts = listOf(
                Accounts.AccountDef(
                    "service",
                    "0xe91e497115b9731b",
                    "11ddf0c418df8c0bda9d7d74bda7a86365b74684e3aee08b3935e5e0bda65b927f654356703f3e2ac341b8b3939c2c925196eb64724e34df99fcf477659c5959",
                    "780e9ad4acbc6f07f08f0c817792cb76a2b7ac564c149b166db6323a70f849fe"
                )
            )
            val accounts = Accounts(api, existingAccounts, emptyList())

            val contracts = Contracts(
                "cadence", "contracts", coreContracts, mapOf(
                    "0xe91e497115b9731b" to listOf(
                        "SaleOrder",
                        "RegularSaleOrder",
                        "AssetBound",
                        "MarketFee",
                        "StoreShowCase",
                        "FtPathMapper",
                        "NFTPlus",
                        "CommonNFT",
                    )
                ).flatMap { (address, contracts) -> contracts.map { it to address } }.toMap()
            )
            contracts.saveSedConfig()
            val deployScheme = DeployScheme(api, contracts, accounts)
            deployScheme.deploy()
            val service = accounts.serviceAccount
            val converter = SourceConverter(coreContracts + contracts.deployAddresses)
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

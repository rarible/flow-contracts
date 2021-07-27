import contracts.CommonNFT
import contracts.FlowToken
import contracts.StoreShowCase
import org.onflow.sdk.Flow

class App {
    companion object {
        private val emulatorCoreContracts = mapOf(
            "FlowFees" to "0xe5a8b7f23e8b548f",
            "FlowServiceAccount" to "0xf8d6e0586b0a20c7",
            "FlowStorageFees" to "0xf8d6e0586b0a20c7",
            "FlowToken" to "0x0ae53cb6e3f42a79",
            "FungibleToken" to "0xee82856bf20e2aa6",
        )

        @JvmStatic
        fun main(args: Array<String>) {
            val api = Flow.newAccessApi("localhost", 3569)
            val existingAccounts = listOf(
                Accounts.AccountDef(
                    "service",
                    "0xf8d6e0586b0a20c7",
                    "ed0d199902395428026e5055bfeaa7e823c5e1da978b3088dc6ef11ee74f4503526db91baca581dd0de140a0cab8a6234b01e9b5849dd941b556999f3c1eed16",
                    "ba412c8efe86d806da91ad655bf2c6bcf8fa1c8f8a2bb5cdd0de43fcaab1a2f9"
                )
            )
            val accounts = Accounts(
                api,
                existingAccounts,
                listOf("alice", "bob", "eve")
            )
            val contracts = Contracts(
                "cadence", "contracts", emulatorCoreContracts, mapOf(
                    "0xf8d6e0586b0a20c7" to listOf(
                        "NonFungibleToken",
                        "NFTProvider",
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
            val alice = accounts.accounts["alice"]!!
            val bob = accounts.accounts["bob"]!!
            val eve = accounts.accounts["eve"]!!

            val converter = SourceConverter(emulatorCoreContracts + contracts.deployAddresses)
            val flowToken = FlowToken(api, converter)
            val commonNFT = CommonNFT(api, converter)
            val showCase = StoreShowCase(api, converter)

            listOf(alice, bob, eve).forEach {
                commonNFT.init(it)
                flowToken.transferFlow(service, 10.0, it.addressHex)
                flowToken.getBalance(it.addressHex)
            }
            commonNFT.check(alice.addressHex)
            commonNFT.getIds(alice.addressHex)
            commonNFT.check("0xf8d6e0586b0a20c7")
            commonNFT.getIds("0xf8d6e0586b0a20c7")

            commonNFT.mint(accounts.serviceAccount, "Hello, world!", mapOf(
                alice.addressHex to 2.0,
                bob.addressHex to 3.0,
                eve.addressHex to 5.0,
            ))
//            commonNFT.borrowNft("0xf8d6e0586b0a20c7", 1U)
//            commonNFT.transfer(accounts.serviceAccount, 1U, accounts.serviceAccount.address.formatted)
//            val r4 = commonNFT.burn(accounts.serviceAccount, 5U)
//            println(r4)

//            showCase.getSaleIds(alice.addressHex)
            showCase.regularSaleCreate(accounts.serviceAccount, 7U, 0.2045)
            showCase.regularSalePurchaseExt(alice, service.addressHex, 108U)
//            commonNFT.transfer(accounts.serviceAccount, 2U, alice.addressHex)
//            commonNFT.clean(alice)
            showCase.getSaleIds(service.addressHex)
        }
    }
}

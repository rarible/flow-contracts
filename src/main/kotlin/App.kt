import org.onflow.sdk.Flow
import org.onflow.sdk.cadence.ArrayField

class App {
    companion object {
        @JvmStatic
        fun main(args: Array<String>) {
            val api = Flow.newAccessApi("localhost", 3569)
            val accounts = Accounts(
                api,
                listOf(
                    Accounts.AccountDef(
                        "service",
                        "0xf8d6e0586b0a20c7",
                        "ed0d199902395428026e5055bfeaa7e823c5e1da978b3088dc6ef11ee74f4503526db91baca581dd0de140a0cab8a6234b01e9b5849dd941b556999f3c1eed16",
                        "ba412c8efe86d806da91ad655bf2c6bcf8fa1c8f8a2bb5cdd0de43fcaab1a2f9"
                    )
                ),
                listOf("alice", "bob", "eve")
            )
            val contracts = Contracts(
                "cadence", "contracts", mapOf(
                    "FungibleToken" to "0xee82856bf20e2aa6",
                    "FlowToken" to "0x0ae53cb6e3f42a79"
                ), mapOf(
                    "0xf8d6e0586b0a20c7" to listOf(
                        "NonFungibleToken",
                        "NFTProvider",
                        "SaleOrder",
                        "RegularSaleOrder",
                        "AssetBound",
                        "MarketFee",
                        "StoreShowCase",
                        "FtPathMapper",
                    )
                ).flatMap { (address, contracts) -> contracts.map { it to address } }.toMap()
            )
            contracts.saveSedConfig()
            val deployScheme = DeployScheme(api, contracts, accounts)
            deployScheme.deploy()
            val scripts = Scripts(api, "cadence", contracts.aliasMapping)
            val transactions = Transactions(api, "cadence", contracts.aliasMapping)
            println(scripts.checkHolder("0xf8d6e0586b0a20c7"))
            val r1 = transactions.mintNftPublic(accounts.serviceAccount, "link://hello-world")
            val message = scripts.getNftIds("0xf8d6e0586b0a20c7")
            println(message)
            val x = ((message.jsonCadence as ArrayField).value!![0].value as String).toULongOrNull()
            println(r1)
            println(x)
        }
    }
}

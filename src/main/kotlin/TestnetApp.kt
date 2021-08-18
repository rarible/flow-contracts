import util.Accounts
import util.Contracts
import util.DeployScheme
import util.SourceConverter

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
        }
    }
}

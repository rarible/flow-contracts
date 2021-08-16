import contracts.CommonNFT
import contracts.FlowToken
import contracts.NFTStorefront
import contracts.StoreShowCase
import util.Accounts
import util.Contracts
import util.DeployScheme
import util.SourceConverter

class Context(chain: Chain, addonAccounts: List<String> = listOf()) {
    val api = chain.api()
    val accounts = Accounts(api, listOf(Emulator.serviceAccount), addonAccounts)
    val contracts = Contracts(
        "cadence",
        "contracts",
        chain.coreContracts,
        mapOf(Emulator.serviceAccount.addressHex to chain.coreContractsDeploy + Config.contractsToDeploy)
            .flatMap { (address, contracts) -> contracts.map { it to address } }
            .toMap()
    )
    val deployScheme = DeployScheme(api, contracts, accounts)
    val converter = SourceConverter(Emulator.coreContracts + contracts.deployAddresses)
    val flowToken = FlowToken(this, converter)
    val commonNFT = CommonNFT(this, converter)
    val showCase = StoreShowCase(this, converter)
    val nftStorefront = NFTStorefront(this, converter)
}

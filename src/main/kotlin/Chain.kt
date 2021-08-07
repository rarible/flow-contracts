import org.onflow.sdk.FlowAccessApi
import util.Accounts

interface Chain {
    val coreContracts: Map<String, String>
    val serviceAccount: Accounts.AccountDef
    val coreContractsDeploy: List<String>
    fun api(): FlowAccessApi
}
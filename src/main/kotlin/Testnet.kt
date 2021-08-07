import org.onflow.sdk.Flow
import util.Accounts

object Testnet : Chain {

    override fun api() = Flow.newAccessApi("access.devnet.nodes.onflow.org", 9000)

    override val coreContracts = mapOf(
        "FlowFees" to "0x912d5440f7e3769e",
        "FlowToken" to "0x7e60df042a9c0868",
        "FungibleToken" to "0x9a0766d93b6608b7",
        "NonFungibleToken" to "0x631e88ae7f1d7c20",
        "FUSD" to "0xe223d8a629e49c68"
    )

    override val serviceAccount = Accounts.AccountDef(
        "service",
        "0xe91e497115b9731b",
        "11ddf0c418df8c0bda9d7d74bda7a86365b74684e3aee08b3935e5e0bda65b927f654356703f3e2ac341b8b3939c2c925196eb64724e34df99fcf477659c5959",
        "780e9ad4acbc6f07f08f0c817792cb76a2b7ac564c149b166db6323a70f849fe"
    )

    override val coreContractsDeploy = emptyList<String>()
}

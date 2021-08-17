import com.nftco.flow.sdk.Flow
import util.Accounts

object Emulator : Chain {

    override fun api() = Flow.newAccessApi("localhost", 3569)

    override val coreContracts = mapOf(
        "FlowFees" to "0xe5a8b7f23e8b548f",
        "FlowToken" to "0x0ae53cb6e3f42a79",
        "FungibleToken" to "0xee82856bf20e2aa6",
    )

    override val serviceAccount = Accounts.AccountDef(
        "service",
        "0xf8d6e0586b0a20c7",
        "ed0d199902395428026e5055bfeaa7e823c5e1da978b3088dc6ef11ee74f4503526db91baca581dd0de140a0cab8a6234b01e9b5849dd941b556999f3c1eed16",
        "ba412c8efe86d806da91ad655bf2c6bcf8fa1c8f8a2bb5cdd0de43fcaab1a2f9"
    )

    override val coreContractsDeploy = listOf("NonFungibleToken")
}

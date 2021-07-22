import org.junit.jupiter.api.Test
import org.junit.jupiter.api.assertDoesNotThrow
import org.onflow.sdk.Flow
import kotlin.test.assertEquals

internal class AccountsTest {
    private val api = Flow.newAccessApi("localhost", 3569)
    private val accounts = Accounts(
        api,
        listOf(Accounts.AccountDef("service", "0xf8d6e0586b0a20c7", "ed0d199902395428026e5055bfeaa7e823c5e1da978b3088dc6ef11ee74f4503526db91baca581dd0de140a0cab8a6234b01e9b5849dd941b556999f3c1eed16", "ba412c8efe86d806da91ad655bf2c6bcf8fa1c8f8a2bb5cdd0de43fcaab1a2f9")),
        listOf("alice", "bob", "eve")
    )

    @Test
    fun readAccount() {
        val address = "0xf8d6e0586b0a20c7"
        assertEquals(accounts.getAccount(address)!!.address.formatted, address)
    }

    @Test
    fun checkService() {
        assertEquals(accounts.serviceAccount.address.formatted, "0xf8d6e0586b0a20c7")
    }

    @Test
    fun `is created`() {
        assertEquals(accounts.accounts.map { it.value.address.formatted }.size, 4)
    }

    @Test
    fun `test app`() {
        assertDoesNotThrow { App.main(emptyArray()) }
    }
}

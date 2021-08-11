package util

import org.onflow.sdk.*
import org.onflow.sdk.cadence.AddressField
import org.onflow.sdk.crypto.Crypto
import org.onflow.sdk.crypto.KeyPair
import org.onflow.sdk.crypto.PublicKey

class Accounts(private val api: FlowAccessApi, load: List<AccountDef>, create: List<String>) {

    companion object {
        const val serviceAccountName = "service"
    }

    data class AccountDef(
        val name: String,
        val addressHex: String,
        val publicKey: String,
        val privateKey: String,
    )

    val byName: MutableMap<String, Account> = mutableMapOf()
    val byAddress: MutableMap<String, Account> = mutableMapOf()
    val serviceAccount: Account

    init {
        load.forEach(this@Accounts::loadAccount)
        serviceAccount = byName[serviceAccountName] ?: throw IllegalStateException("Not found service account")
        create.forEach(this@Accounts::createAndLoadAccount)
    }

    operator fun get(key: String) = byName[key]

    fun loadAccount(accountDef: AccountDef) = Account(
        accountDef.name,
        KeyPair(Crypto.decodePrivateKey(accountDef.privateKey), Crypto.decodePublicKey(accountDef.publicKey)),
        api.getAccountAtLatestBlock(FlowAddress(accountDef.addressHex))!!
    ).also(this@Accounts::addAccount)

    fun createAndLoadAccount(name: String): Account {
        val keyPair = Crypto.generateKeyPair()
        return Account(
            name,
            keyPair,
            api.getAccountAtLatestBlock(createAccount(keyPair.public))!!
        ).also(this@Accounts::addAccount)
    }

    fun createAccount(publicKey: PublicKey) =
        api.tx(serviceAccount, SourceLoader.fromResource("create_account.cdc")) {
            val accountKey = FlowAccountKey(
                publicKey = FlowPublicKey(publicKey.hex),
                signAlgo = SignatureAlgorithm.ECDSA_P256,
                hashAlgo = HashAlgorithm.SHA3_256,
                weight = 1000
            )
            arg { string(accountKey.encoded.bytesToHex()) }
        }.let {
            FlowAddress(it.second["flow.AccountCreated"]?.get<AddressField>("address")?.value!!)
        }

    private fun addAccount(account: Account) {
        byName[account.name] = account
        byAddress[account.addressHex] = account
    }
}

package util

import org.onflow.sdk.FlowAccount
import org.onflow.sdk.crypto.KeyPair

data class Account(
    val name: String,
    val keyPair: KeyPair,
    val flow: FlowAccount,
) {
    val address = flow.address
    val addressHex = flow.address.formatted
}

package util

import com.nftco.flow.sdk.FlowAccount
import com.nftco.flow.sdk.crypto.KeyPair

data class Account(
    val name: String,
    val keyPair: KeyPair,
    val flow: FlowAccount,
) {
    val address = flow.address
    val addressHex = flow.address.formatted
}

// This transaction mints new FUSD and increases the total supply.
// The minted FUSD is deposited into the recipient account.
//
// Parameters:
// - amount: The amount of FUSD to transfer (e.g. 10.0)
// - to: The recipient account address.
//
// This transaction will fail if the authorizer does not have and FUSD.MinterProxy
// resource. Use the setup_fusd_minter.cdc and deposit_fusd_minter.cdc transactions
// to configure the minter proxy.
//
// This transaction will fail if the recipient does not have
// an FUSD vault stored in their account. To check if an account has a vault
// or initialize a new vault, use check_fusd_vault_setup.cdc and setup_fusd_vault.cdc
// respectively.

import FungibleToken from "../../contracts/FungibleToken.cdc"
import FUSD from "../../contracts/FUSD.cdc"

transaction(amount: UFix64, to: Address) {

    let tokenMinter: &FUSD.MinterProxy
    let tokenReceiver: &{FungibleToken.Receiver}

    prepare(minterAccount: AuthAccount) {
        self.tokenMinter = minterAccount
            .borrow<&FUSD.MinterProxy>(from: FUSD.MinterProxyStoragePath)
            ?? panic("No minter available")

        self.tokenReceiver = getAccount(to)
            .getCapability(/public/fusdReceiver)!
            .borrow<&{FungibleToken.Receiver}>()
            ?? panic("Unable to borrow receiver reference")
    }

    execute {
        let mintedVault <- self.tokenMinter.mintTokens(amount: amount)

        self.tokenReceiver.deposit(from: <-mintedVault)
    }
}

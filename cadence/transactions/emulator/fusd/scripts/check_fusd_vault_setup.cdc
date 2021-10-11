// This script returns true if the account specified has been properly set up to use FUSD,
// and false otherwise.
//
// If this script returns false, 
// the most likely cause is that the account has not been set up with an FUSD vault.
// To fix this, the user should execute transactions/setup_account.cdc.
//
// Parameters:
// - address: The address of the account to check.

import FungibleToken from "../../../../contracts/core/FungibleToken.cdc"
import FUSD from "../../../../contracts/core/FUSD.cdc"

pub fun main(address: Address): Bool {
    let account = getAccount(address)

    let receiverRef = account.getCapability(/public/fusdReceiver)!
        .borrow<&FUSD.Vault{FungibleToken.Receiver}>()
        ?? nil

    let balanceRef = account.getCapability(/public/fusdBalance)!
        .borrow<&FUSD.Vault{FungibleToken.Balance}>()
        ?? nil

    return (receiverRef != nil) && (balanceRef != nil)
}

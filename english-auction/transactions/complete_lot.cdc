import FungibleToken from "contracts/core/FungibleToken.cdc"
import NonFungibleToken from "contracts/core/NonFungibleToken.cdc"
import EnglishAuction from "contracts/EnglishAuction.cdc"
// {{prelude}}
import FlowToken from "contracts/core/FlowToken.cdc"
import ExampleNFT from "contracts/ExampleNFT.cdc"

pub fun getVaultRef(_ account: AuthAccount): &FlowToken.Vault {
    return account.borrow<&FlowToken.Vault>(from: /storage/flowTokenVault)
        ?? panic("Cannot borrow FlowToken vault from acct storage")
}

pub fun getFTReceiver(_ account: AuthAccount): Capability<&{FungibleToken.Receiver}> {
    return account.getCapability<&{FungibleToken.Receiver}>(/public/flowTokenReceiver)
}

pub fun getFTReceiverByAddress(_ address: Address): Capability<&{FungibleToken.Receiver}> {
    return getAccount(address).getCapability<&{FungibleToken.Receiver}>(/public/flowTokenReceiver)
}

pub fun getNFTReceiver(_ account: AuthAccount): Capability<&{NonFungibleToken.CollectionPublic}> {
    // todo: check presense and create if need
    return account.getCapability<&{NonFungibleToken.CollectionPublic}>(/public/NFTCollection)
}

transaction (lotId: UInt64) {
    prepare(account: AuthAccount) {
    }

    execute {
        EnglishAuction.borrowAuction().completeLot(lotId: lotId)
    }
}

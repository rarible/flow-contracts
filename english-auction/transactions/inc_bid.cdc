import FungibleToken from "../contracts/core/FungibleToken.cdc"
import NonFungibleToken from "../contracts/core/NonFungibleToken.cdc"
import FlowToken from "../contracts/core/FlowToken.cdc"
import ExampleNFT from "../contracts/ExampleNFT.cdc"
import EnglishAuction from "../contracts/EnglishAuction.cdc"

pub fun getVaultRef(_ account: AuthAccount): &FlowToken.Vault {
    return account.borrow<&FlowToken.Vault>(from: /storage/flowTokenVault)
        ?? panic("Cannot borrow FlowToken vault from acct storage")
}

pub fun getFTReceiverByAddress(_ address: Address): Capability<&{FungibleToken.Receiver}> {
    return getAccount(address).getCapability<&{FungibleToken.Receiver}>(/public/flowTokenReceiver)
}

pub fun getNFTReceiver(_ account: AuthAccount): Capability<&{NonFungibleToken.CollectionPublic}> {
    // todo: check presense and create if need
    return account.getCapability<&{NonFungibleToken.CollectionPublic}>(/public/NFTCollection)
}

transaction (lotId: UInt64, amount: UFix64) {
    let auction: &EnglishAuction.AuctionHouse
    let address: Address
    let vault: @FungibleToken.Vault

    prepare(account: AuthAccount) {
        self.auction = EnglishAuction.borrowAuction()
        self.address = account.address
        self.vault <- getVaultRef(account).withdraw(amount: amount)
    }

    execute {
        self.auction.increaseBid(
            lotId: lotId,
            address: self.address,
            newVault: <- self.vault,
        )
    }
}

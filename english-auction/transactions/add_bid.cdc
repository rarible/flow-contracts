import FungibleToken from "contracts/core/FungibleToken.cdc"
import NonFungibleToken from "contracts/core/NonFungibleToken.cdc"
import FlowToken from "contracts/core/FlowToken.cdc"
import ExampleNFT from "contracts/ExampleNFT.cdc"
import EnglishAuction from "contracts/EnglishAuction.cdc"

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

transaction (lotId: UInt64, amount: UFix64, parts: {Address:UFix64}) {
    let auction: &EnglishAuction.AuctionHouse
    let vault: @FungibleToken.Vault
    let reward: Capability<&{NonFungibleToken.CollectionPublic}>
    let refund: Capability<&{FungibleToken.Receiver}>

    prepare(account: AuthAccount) {
        self.auction = EnglishAuction.borrowAuction()
        var r: UFix64 = 0.0
        for key in parts.keys { r = r + parts[key]! } // todo
        self.vault <- getVaultRef(account).withdraw(amount: amount * (1.0+r))
        self.reward = getNFTReceiver(account)
        self.refund = getFTReceiver(account)
    }

    execute {
        let payouts: [EnglishAuction.Payout] = []
        for key in parts.keys {
            payouts.append(EnglishAuction.Payout(target: getFTReceiverByAddress(key), rate: parts[key]!))
        }

        self.auction.addBid(
            lotId: lotId,
            reward: self.reward,
            refund: self.refund,
            vault: <- self.vault,
            payouts: payouts
        )
    }
}

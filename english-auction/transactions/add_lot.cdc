import FungibleToken from "../contracts/core/FungibleToken.cdc"
import NonFungibleToken from "../contracts/core/NonFungibleToken.cdc"
import EnglishAuction from "../contracts/EnglishAuction.cdc"
// {{prelude}}
import FlowToken from "../contracts/core/FlowToken.cdc"
import ExampleNFT from "../contracts/ExampleNFT.cdc"

pub fun getFTReceiverByAddress(_ address: Address): Capability<&{FungibleToken.Receiver}> {
    return getAccount(address).getCapability<&{FungibleToken.Receiver}>(/public/flowTokenReceiver)
}

transaction (
    tokenId: UInt64,
    minimumBid: UFix64,
    buyoutPrice: UFix64,
    increment: UFix64,
    startAt: UFix64,
    duration: UFix64,
    parts: {Address:UFix64}
) {
    let auction: &EnglishAuction.AuctionHouse
    let item: @NonFungibleToken.NFT
    let reward: Capability<&{FungibleToken.Receiver}>
    let refund: Capability<&{NonFungibleToken.CollectionPublic}>

    prepare(account: AuthAccount) {
        self.auction = EnglishAuction.borrowAuction()
        let collection = account.borrow<&ExampleNFT.Collection>(from: /storage/NFTCollection)
                ?? panic("Missing NFT collection on signer account")
        self.item <- collection.withdraw(withdrawID: tokenId)
        self.reward = account.getCapability<&{FungibleToken.Receiver}>(/public/flowTokenReceiver)
        self.refund = account.getCapability<&{NonFungibleToken.CollectionPublic}>(/public/NFTCollection)
        // {{checks}}
        // self.item <- account.{{NFTCollectionRef}}.withdraw(withdrawID: 0)
        // self.reward = account.{{FTReceiverCap}}
        // self.refund = account.{{NFTReceiverCap}}
    }

    execute {
        let payouts: [EnglishAuction.Payout] = []
        for key in parts.keys {
            payouts.append(EnglishAuction.Payout(target: getFTReceiverByAddress(key), rate: parts[key]!))
        }

        self.auction.addLot(
            reward: self.reward,
            refund: self.refund,
            item: <- self.item,
            bidType: Type<FlowToken>(),
            minimumBid: minimumBid,
            buyoutPrice: buyoutPrice,
            increment: increment,
            startAt: startAt,
            duration: duration,
            payouts: payouts
        )
    }
}

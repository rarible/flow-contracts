import FungibleToken from "../../../../../flow-contracts/cadence/contracts/core/FungibleToken.cdc"
import NonFungibleToken from "../../../../../flow-contracts/cadence/contracts/core/NonFungibleToken.cdc"
import RaribleOpenBid from "../../../../../flow-contracts/cadence/contracts/RaribleOpenBid.cdc"
import FlowToken from "../../../../../flow-contracts/cadence/contracts/core/FlowToken.cdc"
import Evolution from "../../../../../flow-contracts/cadence/contracts/third-party/Evolution.cdc"

transaction(bidId: UInt64, openBidAddress: Address) {
    let openBid: &RaribleOpenBid.OpenBid{RaribleOpenBid.OpenBidPublic}
    let bid: &RaribleOpenBid.Bid{RaribleOpenBid.BidPublic}
    let nft: @NonFungibleToken.NFT
    let mainVault: &{FungibleToken.Receiver}

    prepare(account: AuthAccount) {
        self.openBid = getAccount(openBidAddress)
            .getCapability(RaribleOpenBid.OpenBidPublicPath)!
            .borrow<&RaribleOpenBid.OpenBid{RaribleOpenBid.OpenBidPublic}>()
            ?? panic("Could not borrow OpenBid from provided address")

        self.bid = self.openBid.borrowBid(bidId: bidId) 
            ?? panic("No Offer with that ID in OpenBid")

        let nftId = self.bid.getDetails().nftId
        let nftCollection = account.borrow<&Evolution.Collection>(from: /storage/f4264ac8f3256818_Evolution_Collection) 
            ?? panic("Cannot borrow NFT collection receiver from account")
        self.nft <- nftCollection.withdraw(withdrawID: nftId)

        self.mainVault = account.borrow<&{FungibleToken.Receiver}>(from: /storage/flowTokenVault)
            ?? panic("Cannot borrow FlowToken vault from account storage")
    }

    execute {
        let vault <- self.bid.purchase(item: <-self.nft)!
        self.mainVault.deposit(from: <-vault)
        self.openBid.cleanup(bidId: bidId)
    }
}

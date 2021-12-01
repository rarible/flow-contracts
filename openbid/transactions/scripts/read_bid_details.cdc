import RaribleOpenBid from "../../contracts/RaribleOpenBid.cdc"

// This script returns the details for a Bid within a OpenBid

pub fun main(account: Address, BidResourceID: UInt64): RaribleOpenBid.BidDetails {
    let OpenBidRef = getAccount(account)
        .getCapability<&RaribleOpenBid.OpenBid{RaribleOpenBid.OpenBidPublic}>(
            RaribleOpenBid.OpenBidPublicPath
        )
        .borrow()
        ?? panic("Could not borrow public OpenBid from address")

    let Bid = OpenBidRef.borrowBid(BidResourceID: BidResourceID)
        ?? panic("No item with that ID")
    
    return Bid.getDetails()
}

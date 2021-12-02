import RaribleOpenBid from "../../../../../flow-contracts/cadence/contracts/RaribleOpenBid.cdc"

// This script returns an array of all the nft uuids for sale through a OpenBid

pub fun main(account: Address): [UInt64] {
    let OpenBidRef = getAccount(account)
        .getCapability<&RaribleOpenBid.OpenBid{RaribleOpenBid.OpenBidPublic}>(
            RaribleOpenBid.OpenBidPublicPath
        )
        .borrow()
        ?? panic("Could not borrow public OpenBid from address")
    
    return OpenBidRef.getBidIds()
}

import RaribleOpenBid from "../../../../flow-contracts/cadence/contracts/RaribleOpenBid.cdc"

transaction(bidId: UInt64) {
    let openBid: &RaribleOpenBid.OpenBid{RaribleOpenBid.OpenBidManager}

    prepare(acct: AuthAccount) {
        self.openBid = acct.borrow<&RaribleOpenBid.OpenBid{RaribleOpenBid.OpenBidManager}>(from: RaribleOpenBid.OpenBidStoragePath)
            ?? panic("Missing or mis-typed RaribleOpenBid.OpenBid")
    }

    execute {
        self.openBid.removeBid(bidId: bidId)
    }
}
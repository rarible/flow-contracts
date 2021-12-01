import RaribleOpenBid from "../contracts/RaribleOpenBid.cdc"

transaction(bidId: UInt64, openBidAddress: Address) {
    let openBid: &RaribleOpenBid.OpenBid{RaribleOpenBid.OpenBidPublic}

    prepare(acct: AuthAccount) {
        self.openBid = getAccount(openBidAddress)
            .getCapability<&RaribleOpenBid.OpenBid{RaribleOpenBid.OpenBidPublic}>(
                RaribleOpenBid.OpenBidPublicPath
            )!
            .borrow()
            ?? panic("Could not borrow OpenBid from provided address")
    }

    execute {
        self.openBid.cleanup(bidId: bidId)
    }
}

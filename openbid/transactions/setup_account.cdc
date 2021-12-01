import RaribleOpenBid from "../contracts/RaribleOpenBid.cdc"

// This transaction installs the OpenBid resource in an account.

transaction {
    prepare(acct: AuthAccount) {
        if acct.borrow<&RaribleOpenBid.OpenBid>(from: RaribleOpenBid.OpenBidStoragePath) == nil {
            let OpenBid <- RaribleOpenBid.createOpenBid() as! @RaribleOpenBid.OpenBid
            acct.save(<-OpenBid, to: RaribleOpenBid.OpenBidStoragePath)
            acct.link<&RaribleOpenBid.OpenBid{RaribleOpenBid.OpenBidPublic}>(RaribleOpenBid.OpenBidPublicPath, target: RaribleOpenBid.OpenBidStoragePath)
        }
    }
}

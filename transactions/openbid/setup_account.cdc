import RaribleOpenBid from "../../../../flow-contracts/cadence/contracts/RaribleOpenBid.cdc"

// This transaction installs the OpenBid resource in an account.

transaction {
    prepare(acct: AuthAccount) {
        if acct.borrow<&RaribleOpenBid.OpenBid>(from: RaribleOpenBid.OpenBidStoragePath) == nil {
            let openBid <- RaribleOpenBid.createOpenBid()
            acct.save(<-openBid, to: RaribleOpenBid.OpenBidStoragePath)
            acct.link<&RaribleOpenBid.OpenBid{RaribleOpenBid.OpenBidPublic}>(RaribleOpenBid.OpenBidPublicPath, target: RaribleOpenBid.OpenBidStoragePath)
        }
    }
}

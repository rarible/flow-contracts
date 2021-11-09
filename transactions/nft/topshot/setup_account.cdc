import TopShot from "../../../contracts/third-party/TopShot.cdc"

// Setup storage for TopShot on signer account
//
transaction {
    prepare(acct: AuthAccount) {
        if acct.borrow<&TopShot.Collection>(from: /storage/MomentCollection) == nil {
            let collection <- TopShot.createEmptyCollection() as! @TopShot.Collection
            acct.save(<-collection, to: /storage/MomentCollection)
            acct.link<&{TopShot.MomentCollectionPublic}>(/public/MomentCollection, target: /storage/MomentCollection)
        }
    }
}
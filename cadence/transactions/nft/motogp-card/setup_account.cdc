import MotoGPCard from "../../../contracts/third-party/MotoGPCard.cdc"

// Setup storage for MotoGPCard on signer account
//
transaction {
    prepare(acct: AuthAccount) {
        if acct.borrow<&MotoGPCard.Collection>(from: /storage/motogpCardCollection) == nil {
            let collection <- MotoGPCard.createEmptyCollection() as! @MotoGPCard.Collection
            acct.save(<-collection, to: /storage/motogpCardCollection)
            acct.link<&MotoGPCard.Collection{MotoGPCard.ICardCollectionPublic}>(/public/motogpCardCollection, target: /storage/motogpCardCollection)
        }
    }
}
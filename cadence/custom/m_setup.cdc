import MotoGPCard from "../contracts/MotoGPCard.cdc"
import MotoGPPack from "../contracts/MotoGPPack.cdc"

transaction {
    prepare(acct: AuthAccount) {
        if acct.borrow<&MotoGPPack.Collection>(from: /storage/motogpPackCollection) == nil {
            let packCollection <- MotoGPPack.createEmptyCollection()
            acct.save(<-packCollection, to: /storage/motogpPackCollection)
            acct.link<&MotoGPPack.Collection{MotoGPPack.IPackCollectionPublic, MotoGPPack.IPackCollectionAdminAccessible}>(/public/motogpPackCollection, target: /storage/motogpPackCollection)
        }
        if acct.borrow<&MotoGPCard.Collection>(from: /storage/motogpCardCollection) == nil {
            let cardCollection <- MotoGPCard.createEmptyCollection()
            acct.save(<-cardCollection, to: /storage/motogpCardCollection)
            acct.link<&MotoGPCard.Collection{MotoGPCard.ICardCollectionPublic}>(/public/motogpCardCollection, target: /storage/motogpCardCollection)
        }
    }

    execute {
    }
}
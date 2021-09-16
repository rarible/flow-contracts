import PackOpener from 0xPACKOPENER
import MotoGPCard from 0xMOTOGPCARD
import MotoGPPack from 0xMOTOGPPACK
import MotoGPTransfer from 0xMOTOGPTRANSFER

transaction(id: UInt64, toAddress: Address) {
    var packCollectionRef: &MotoGPPack.Collection
    var packOpenerCollectionRef: &PackOpener.Collection

    prepare(acct: AuthAccount) {
        self.packCollectionRef = acct.borrow<&MotoGPPack.Collection>(from: /storage/motogpPackCollection)
            ?? panic("Could not borrow AuthAccount''s Pack collection")
        if acct.borrow<&PackOpener.Collection>(from: /storage/motogpPackOpenerCollection) == nil {
            let cardCollectionCap: Capability<&MotoGPCard.Collection{MotoGPCard.ICardCollectionPublic}> = acct.getCapability<&MotoGPCard.Collection{MotoGPCard.ICardCollectionPublic}>(/public/motogpCardCollection)
            let packOpenerCollection <- PackOpener.createEmptyCollection(cardCollectionCap: cardCollectionCap)
            acct.save(<- packOpenerCollection, to: PackOpener.packOpenerStoragePath)
            acct.link<&PackOpener.Collection{PackOpener.IPackOpenerPublic}>(PackOpener.packOpenerPublicPath, target: PackOpener.packOpenerStoragePath) 
        }

        self.packOpenerCollectionRef = acct.borrow<&PackOpener.Collection>(from: PackOpener.packOpenerStoragePath)
            ?? panic("Could not borrow AuthAccount''s PackOpener collection")
    }

    execute {
        let pack <- self.packCollectionRef.withdraw(withdrawID: id) as! @MotoGPPack.NFT
        MotoGPTransfer.transferPackToPackOpenerCollection(pack: <- pack, toCollection: self.packOpenerCollectionRef, toAddress: toAddress)
    }
}
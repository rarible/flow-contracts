import NonFungibleToken from "../../contracts/core/NonFungibleToken.cdc"
import RaribleNFT from "../../contracts/RaribleNFT.cdc"

// Mint RaribleNFT token to signer acct
//
transaction(metadata: String, royalties: [RaribleNFT.Royalty]) {
    let minter: Capability<&RaribleNFT.Minter>
    let receiver: Capability<&{NonFungibleToken.Receiver}>

    prepare(acct: AuthAccount) {
        if acct.borrow<&RaribleNFT.Collection>(from: RaribleNFT.collectionStoragePath) == nil {
            let collection <- RaribleNFT.createEmptyCollection() as! @RaribleNFT.Collection
            acct.save(<- collection, to: RaribleNFT.collectionStoragePath)
            acct.link<&{NonFungibleToken.CollectionPublic,NonFungibleToken.Receiver}>(RaribleNFT.collectionPublicPath, target: RaribleNFT.collectionStoragePath)
        }

        self.minter = RaribleNFT.minter()
        self.receiver = acct.getCapability<&{NonFungibleToken.Receiver}>(RaribleNFT.collectionPublicPath)
    }

    execute {
        let minter = self.minter.borrow() ?? panic("Could not borrow receiver capability (maybe receiver not configured?)")
        minter.mintTo(creator: self.receiver, metadata: {"metaURI": metadata}, royalties: royalties)
    }
}

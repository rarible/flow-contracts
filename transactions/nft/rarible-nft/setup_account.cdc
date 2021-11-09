import NonFungibleToken from "../../../contracts/core/NonFungibleToken.cdc"
import RaribleNFT from "../../../contracts/RaribleNFT.cdc"

// Setup storage for RaribleNFT on signer account
//
transaction {
    prepare(acct: AuthAccount) {
        if acct.borrow<&RaribleNFT.Collection>(from: RaribleNFT.collectionStoragePath) == nil {
            let collection <- RaribleNFT.createEmptyCollection() as! @RaribleNFT.Collection
            acct.save(<-collection, to: RaribleNFT.collectionStoragePath)
            acct.link<&{NonFungibleToken.CollectionPublic,NonFungibleToken.Receiver}>(RaribleNFT.collectionPublicPath, target: RaribleNFT.collectionStoragePath)
        }
    }
}
import NonFungibleToken from "../../../contracts/core/NonFungibleToken.cdc"
import CommonNFT from "../../../contracts/CommonNFT.cdc"

// Setup storage for CommonNFT on signer account
//
transaction {
    prepare(acct: AuthAccount) {
        if acct.borrow<&CommonNFT.Collection>(from: CommonNFT.collectionStoragePath) == nil {
            let collection <- CommonNFT.createEmptyCollection() as! @CommonNFT.Collection
            acct.save(<-collection, to: CommonNFT.collectionStoragePath)
            acct.link<&{NonFungibleToken.CollectionPublic,NonFungibleToken.Receiver}>(CommonNFT.collectionPublicPath, target: CommonNFT.collectionStoragePath)
        }
    }
}
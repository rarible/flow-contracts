import NonFungibleToken from "../../contracts/core/NonFungibleToken.cdc"
import RaribleNFT from "../../contracts/RaribleNFT.cdc"

transaction {
    prepare(account: AuthAccount) {
        if account.borrow<&RaribleNFT.Collection>(from: RaribleNFT.collectionStoragePath) == nil {
            let collection <- RaribleNFT.createEmptyCollection() as! @RaribleNFT.Collection
            account.save(<- collection, to: RaribleNFT.collectionStoragePath)
            account.link<&{NonFungibleToken.CollectionPublic,NonFungibleToken.Receiver}>(RaribleNFT.collectionPublicPath, target: RaribleNFT.collectionStoragePath)
        }
    }
}

import NonFungibleToken from 0xNONFUNGIBLETOKEN
import CommonNFT from 0xCOMMONNFT
import StoreShowCase from 0xSTORESHOWCASE

transaction {
    prepare(account: AuthAccount) {
        if account.borrow<&CommonNFT.Collection>(from: CommonNFT.collectionStoragePath) == nil {
            let collection <- CommonNFT.createEmptyCollection() as! @CommonNFT.Collection
            account.save(<- collection, to: CommonNFT.collectionStoragePath)
            account.link<&{NonFungibleToken.CollectionPublic,NonFungibleToken.Receiver}>(CommonNFT.collectionPublicPath, target: CommonNFT.collectionStoragePath)
        }
        if account.borrow<&StoreShowCase.ShowCase>(from: StoreShowCase.storeShowCaseStoragePath) == nil {
            let showCase <- StoreShowCase.createShowCase()
            account.save(<- showCase, to: StoreShowCase.storeShowCaseStoragePath)
            account.link<&{StoreShowCase.ShowCasePublic}>(StoreShowCase.storeShowCasePublicPath, target: StoreShowCase.storeShowCaseStoragePath)
        }
    }
}

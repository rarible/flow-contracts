import CommonNFT from 0xCOMMONNFT
import StoreShowCase from 0xSTORESHOWCASE

transaction {
    prepare(account: AuthAccount) {
        CommonNFT.collectionRef(account)
        StoreShowCase.showCase(account)
    }
}

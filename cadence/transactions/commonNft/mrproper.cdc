import NonFungibleToken from 0xNONFUNGIBLETOKEN
import CommonNFT from 0xCOMMONNFT

transaction {
    prepare(account: AuthAccount) {
        CommonNFT.deinit(account)
    }
}
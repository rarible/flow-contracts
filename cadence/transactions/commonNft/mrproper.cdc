import NonFungibleToken from 0xNONFUNGIBLETOKEN
import CommonNFT from 0xCOMMONNFT

transaction {
    prepare(account: AuthAccount) {
        account.unlink(self.minterPublicPath)
        destroy <- account.load<@AnyResource>(from: self.minterStoragePath)

        account.unlink(self.collectionPublicPath)
        destroy <- account.load<@AnyResource>(from: self.collectionStoragePath)
    }
}

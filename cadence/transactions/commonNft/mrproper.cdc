import NonFungibleToken from "../../contracts/NonFungibleToken.cdc"
import CommonNFT from "../../contracts/CommonNFT.cdc"

transaction {
    prepare(account: AuthAccount) {
        account.unlink(self.minterPublicPath)
        destroy <- account.load<@AnyResource>(from: self.minterStoragePath)

        account.unlink(self.collectionPublicPath)
        destroy <- account.load<@AnyResource>(from: self.collectionStoragePath)
    }
}

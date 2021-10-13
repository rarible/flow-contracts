import NonFungibleToken from "../../../contracts/core/NonFungibleToken.cdc"
import CommonNFT from "../../../contracts/CommonNFT.cdc"

transaction {
    prepare(account: AuthAccount) {
        account.unlink(CommonNFT.minterPublicPath)
        destroy <- account.load<@AnyResource>(from: CommonNFT.minterStoragePath)

        account.unlink(CommonNFT.collectionPublicPath)
        destroy <- account.load<@AnyResource>(from: CommonNFT.collectionStoragePath)
    }
}

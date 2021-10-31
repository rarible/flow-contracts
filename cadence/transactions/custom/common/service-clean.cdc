import NonFungibleToken from "../../../contracts/core/NonFungibleToken.cdc"
import RaribleNFT from "../../../contracts/RaribleNFT.cdc"

transaction {
    prepare(account: AuthAccount) {
        account.unlink(RaribleNFT.minterPublicPath)
        destroy <- account.load<@AnyResource>(from: RaribleNFT.minterStoragePath)

        account.unlink(RaribleNFT.collectionPublicPath)
        destroy <- account.load<@AnyResource>(from: RaribleNFT.collectionStoragePath)
    }
}

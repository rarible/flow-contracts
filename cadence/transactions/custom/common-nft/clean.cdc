import CommonNFT from "../../../contracts/CommonNFT.cdc"

transaction {
    prepare(account: AuthAccount) {
        account.unlink(CommonNFT.collectionPublicPath)
        destroy <- account.load<@CommonNFT.Collection>(from: CommonNFT.collectionStoragePath)
    }
}

import CommonNFT from 0xCOMMONNFT

transaction {
    prepare(account: AuthAccount) {
        account.unlink(CommonNFT.collectionPublicPath)
        destroy <- account.load<@Collection>(from: CommonNFT.collectionStoragePath)
    }
}

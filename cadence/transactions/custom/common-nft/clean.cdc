import RaribleNFT from "../../../contracts/RaribleNFT.cdc"

transaction {
    prepare(account: AuthAccount) {
        account.unlink(RaribleNFT.collectionPublicPath)
        destroy <- account.load<@RaribleNFT.Collection>(from: RaribleNFT.collectionStoragePath)
    }
}

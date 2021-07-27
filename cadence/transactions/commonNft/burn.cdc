import CommonNFT from 0xCOMMONNFT

transaction(tokenId: UInt64) {
    prepare(account: AuthAccount) {
        destroy CommonNFT.collectionRef(account).withdraw(withdrawID: tokenId)
    }
}

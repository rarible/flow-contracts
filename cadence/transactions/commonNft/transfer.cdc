import CommonNFT from 0xCOMMONNFT

transaction(tokenId: UInt64, to: Address) {
    prepare(account: AuthAccount) {
        let collection = CommonNFT.collectionRef(account)
        collection.transfer(tokenId: tokenId, to: CommonNFT.receiver(address: to))
    }
}

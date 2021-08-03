import CommonNFT from 0xCOMMONNFT

transaction {
    prepare(account: AuthAccount) {
        CommonNFT.collectionRef(account)
    }
}

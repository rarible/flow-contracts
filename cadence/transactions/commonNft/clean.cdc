import CommonNFT from 0xCOMMONNFT

transaction {
    prepare(account: AuthAccount) {
        CommonNFT.cleanAccount(account)
    }
}

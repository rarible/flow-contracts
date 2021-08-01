import CommonNFT from 0xCOMMONNFT
import CommonNFTDraft from 0xCOMMONNFTDRAFT

transaction {
    prepare(account: AuthAccount) {
        CommonNFT.collectionRef(account)
        CommonNFTDraft.collectionRef(account)
    }
}

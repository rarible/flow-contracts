import CommonNFT from 0xCOMMONNFT

pub fun main(address: Address): Bool {
    return CommonNFT.draftBox(address).check() && CommonNFT.receiver(address).check()
}

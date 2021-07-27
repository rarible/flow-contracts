import CommonNFT from 0xCOMMONNFT

pub fun main(address: Address): Bool {
    return CommonNFT.receiver(address: address).check()
}

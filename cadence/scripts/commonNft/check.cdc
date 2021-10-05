import CommonNFT from "../../contracts/CommonNFT.cdc"

pub fun main(address: Address): Bool {
    return CommonNFT.receiver(address).check()
}

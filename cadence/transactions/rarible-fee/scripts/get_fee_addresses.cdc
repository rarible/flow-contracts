import RaribleFee from "../../../contracts/RaribleFee.cdc"

pub fun main(): {String:Address} {
    return RaribleFee.addressMap()
}

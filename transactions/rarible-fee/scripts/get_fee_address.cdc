import RaribleFee from "../../../contracts/RaribleFee.cdc"

pub fun main(name: String): Address {
    return RaribleFee.feeAddressByName(name)
}

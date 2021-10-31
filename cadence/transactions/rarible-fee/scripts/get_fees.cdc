import RaribleFee from "../../../contracts/RaribleFee.cdc"

pub fun main(): {String:UFix64} {
    return {
        "buyerFee": RaribleFee.buyerFee,
        "sellerFee": RaribleFee.sellerFee
    }
}

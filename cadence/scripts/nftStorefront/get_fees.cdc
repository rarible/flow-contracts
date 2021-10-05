import CommonFee from "../../contracts/CommonFee.cdc"

pub fun main(): {String:UFix64} {
    return {
        "buyerFee": CommonFee.buyerFee,
        "sellerFee": CommonFee.sellerFee
    }
}

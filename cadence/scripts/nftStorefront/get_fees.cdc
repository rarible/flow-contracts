import CommonFee from 0xCOMMONFEE

pub fun main(): {String:UFix64} {
    return {
        "buyerFee": CommonFee.buyerFee,
        "sellerFee": CommonFee.sellerFee
    }
}

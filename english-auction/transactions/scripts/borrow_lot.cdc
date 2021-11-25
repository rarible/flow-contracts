import EnglishAuction from "contracts/EnglishAuction.cdc"

pub fun main(lotId: UInt64): &EnglishAuction.Lot? {
    return EnglishAuction.borrowAuction().borrowLot(lotId: lotId)
}

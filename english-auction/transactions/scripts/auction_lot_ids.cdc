import EnglishAuction from "contracts/EnglishAuction.cdc"

pub fun main(lotId: UInt64): [UInt64] {
    return EnglishAuction.borrowAuction().getIDs()
}

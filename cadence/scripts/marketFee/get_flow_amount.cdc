/**
 * Returns flow amount on fee vault
 */
import MarketFee from "../../contracts/MarketFee.cdc"
import FungibleToken from "../../contracts/FungibleToken.cdc"

pub fun main(): UFix64 {
    return MarketFee.feeBalance.borrow()!.balance
}

/**
 * Returns flow amount on fee vault
 */
import MarketFee from 0xMARKETFEE
import FungibleToken from 0xFUNGIBLETOKEN

pub fun main(): UFix64 {
    return MarketFee.feeBalance.borrow()!.balance
}

/**
 * Returns flow amount on fee vault
 */
import MarketFee from 0xMARKETFEEADDRESS
import FungibleToken from 0xFUNGIBLETOKENADDRESS

pub fun main(): UFix64 {
    return MarketFee.feeBalance.borrow()!.balance
}

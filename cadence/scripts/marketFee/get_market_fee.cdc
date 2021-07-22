/**
 * Return current market fees
 */
import MarketFee from 0xMARKETFEEADDRESS

pub fun main(): {String:UFix64} {
    return MarketFee.getFees()
}

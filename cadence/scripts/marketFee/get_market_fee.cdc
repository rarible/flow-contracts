/**
 * Return current market fees
 */
import MarketFee from "../../contracts/MarketFee.cdc"

pub fun main(): {String:UFix64} {
    return MarketFee.getFees()
}

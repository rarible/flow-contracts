// This script returns the total supply of FUSD.

import FUSD from "../../contracts/FUSD.cdc"

pub fun main(): UFix64 {
    return FUSD.totalSupply
}

import Evolution from "../contracts/Evolution.cdc"

pub fun main(setId: UInt32): &AnyResource {
    return Evolution.borrowSet(setId: setId)
}

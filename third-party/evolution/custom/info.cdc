import Evolution from "../contracts/Evolution.cdc"

pub fun main(setId: UInt32): AnyStruct {
    return Evolution.getItemsInSet(setId: setId)
}

import Evolution from "../contracts/Evolution.cdc"

pub fun main(): AnyStruct {
    return Evolution.getAllItems()
}

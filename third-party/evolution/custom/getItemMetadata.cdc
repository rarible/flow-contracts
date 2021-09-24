import Evolution from "../contracts/Evolution.cdc"

pub fun main(itemId: UInt32): AnyStruct {
    return Evolution.getItemMetadata(itemId: itemId)
}

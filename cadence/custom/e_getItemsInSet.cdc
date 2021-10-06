import Evolution from "../contracts/Evolution.cdc"

pub fun main(setName: String): AnyStruct {
    return Evolution.getSetIdsByName(setName: setName)
}

import Evolution from "../../../contracts/third-party/Evolution.cdc"

pub fun main(setName: String): AnyStruct {
    return Evolution.getSetIdsByName(setName: setName)
}

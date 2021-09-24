
import NonFungibleToken from "../contracts/NonFungibleToken.cdc"
import Evolution from "../contracts/Evolution.cdc"

pub fun main(address: Address): Bool? {
    let account = getAccount(address)
    return getAccount(address).getCapability<&{Evolution.EvolutionCollectionPublic}>(/public/f4264ac8f3256818_Evolution_Collection).check()
}

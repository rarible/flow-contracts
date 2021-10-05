
import NonFungibleToken from "../contracts/NonFungibleToken.cdc"
import Evolution from "../contracts/Evolution.cdc"

pub fun main(address: Address, tokenId: UInt64): &AnyResource {
    let account = getAccount(address)
    let collection = getAccount(address).getCapability<&{Evolution.EvolutionCollectionPublic}>(/public/f4264ac8f3256818_Evolution_Collection).borrow()!
    return collection.borrowNFT(id: tokenId)
}

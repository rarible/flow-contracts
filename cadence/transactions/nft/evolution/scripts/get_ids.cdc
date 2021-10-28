import NonFungibleToken from "../../../../contracts/core/NonFungibleToken.cdc"
import Evolution from "../../../../contracts/third-party/Evolution.cdc"

// Take Evolution ids by account address
//
pub fun main(address: Address): [UInt64]? {
    let collection = getAccount(address)
        .getCapability(/public/f4264ac8f3256818_Evolution_Collection)
        .borrow<&{Evolution.EvolutionCollectionPublic}>()
        ?? panic("NFT Collection not found")
    return collection.getIDs()
}
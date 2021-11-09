
import NonFungibleToken from "../../../../contracts/core/NonFungibleToken.cdc"
import Evolution from "../../../../contracts/third-party/Evolution.cdc"

pub fun main(address: Address, tokenId: UInt64): &AnyResource {
    let account = getAccount(address)
    let collection = getAccount(address).getCapability<&{Evolution.EvolutionCollectionPublic}>(/public/f4264ac8f3256818_Evolution_Collection).borrow()!
    return collection.borrowNFT(id: tokenId)
}

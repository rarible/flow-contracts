import NonFungibleToken from "../../../../contracts/core/NonFungibleToken.cdc"
import Evolution from "../../../../contracts/third-party/Evolution.cdc"

// Take Evolution token props by account address and tokenId
//
pub fun main(address: Address, tokenId: UInt64): &AnyResource {
    let collection = getAccount(address)
        .getCapability(/public/f4264ac8f3256818_Evolution_Collection)
        .borrow<&{Evolution.EvolutionCollectionPublic}>()
        ?? panic("NFT Collection not found")
    return collection.borrowNFT(id: tokenId)
}
import NonFungibleToken from "../../../../contracts/core/NonFungibleToken.cdc"
import MotoGPCard from "../../../../contracts/third-party/MotoGPCard.cdc"

// Take MotoGPCard ids by account address
//
pub fun main(address: Address): [UInt64]? {
    let collection = getAccount(address)
        .getCapability(/public/motogpCardCollection)
        .borrow<&MotoGPCard.Collection{MotoGPCard.ICardCollectionPublic}>()
        ?? panic("NFT Collection not found")
    return collection.getIDs()
}
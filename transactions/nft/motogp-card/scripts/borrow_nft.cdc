import NonFungibleToken from "../../../../contracts/core/NonFungibleToken.cdc"
import MotoGPCard from "../../../../contracts/third-party/MotoGPCard.cdc"

// Take MotoGPCard token props by account address and tokenId
//
pub fun main(address: Address, tokenId: UInt64): &AnyResource {
    let collection = getAccount(address)
        .getCapability(/public/motogpCardCollection)
        .borrow<&MotoGPCard.Collection{MotoGPCard.ICardCollectionPublic}>()
        ?? panic("NFT Collection not found")
    return collection.borrowNFT(id: tokenId)
}
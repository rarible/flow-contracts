import NonFungibleToken from "../../../../contracts/core/NonFungibleToken.cdc"
import MotoGPCard from "../../../../contracts/third-party/MotoGPCard.cdc"

pub fun main(address: Address, tokenId: UInt64): &AnyResource {
    let account = getAccount(address)
    let collection = getAccount(address).getCapability<&{MotoGPCard.ICardCollectionPublic}>(/public/motogpCardCollection).borrow()!
    return collection.borrowCard(id: tokenId)!
}

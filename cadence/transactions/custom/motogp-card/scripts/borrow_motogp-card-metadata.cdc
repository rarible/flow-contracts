import NonFungibleToken from "../../../../contracts/core/NonFungibleToken.cdc"
import MotoGPCard from "../../../../contracts/third-party/MotoGPCard.cdc"
import MotoGPCardMetadata from "../../../../contracts/third-party/MotoGPCardMetadata.cdc"

pub fun main(address: Address, tokenId: UInt64): MotoGPCardMetadata.Metadata? {
    let account = getAccount(address)
    let collection = getAccount(address).getCapability<&{MotoGPCard.ICardCollectionPublic}>(/public/motogpCardCollection).borrow()!
    let ref = collection.borrowCard(id: tokenId)!
    return ref.getCardMetadata()
}


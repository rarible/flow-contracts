import MotoGPCard from 0x01658d9b94068f3c

pub fun main(address: Address, tokenId: UInt64): [AnyStruct] {
    let collection = getAccount(address).getCapability<&{MotoGPCard.ICardCollectionPublic}>(/public/motogpCardCollection).borrow()!
    let card = collection.borrowCard(id: tokenId)!
    return [card, card.getCardMetadata()]
}

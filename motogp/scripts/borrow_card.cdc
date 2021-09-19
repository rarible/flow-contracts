import NonFungibleToken from "../contracts/NonFungibleToken.cdc"
import MotoGPCard from "../contracts/MotoGPCard.cdc"

pub fun main(address: Address, tokenId: UInt64): &AnyResource {
    let account = getAccount(address)
    let collection = getAccount(address).getCapability<&{MotoGPCard.ICardCollectionPublic}>(/public/motogpCardCollection).borrow()!
    return collection.borrowNFT(id: tokenId)
}

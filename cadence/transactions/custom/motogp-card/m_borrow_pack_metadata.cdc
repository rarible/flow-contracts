import NonFungibleToken from "../../../contracts/core/NonFungibleToken.cdc"
import MotoGPPack from "../../../contracts/third-party/MotoGPPack.cdc"

pub fun main(address: Address, tokenId: UInt64): &AnyResource {
    let account = getAccount(address)
    let collection = getAccount(address).getCapability<&{MotoGPPack.IPackCollectionPublic}>(/public/motogpPackCollection).borrow()!
    let ref = collection.borrowPack(id: tokenId)!
    return ref.getPackMetadata()
}

import NonFungibleToken from "../../../contracts/core/NonFungibleToken.cdc"
import MotoGPPack from "../../../contracts/third-party/MotoGPPack.cdc"

pub fun main(address: Address): [UInt64]? {
    let account = getAccount(address)
    let collection = getAccount(address).getCapability<&{MotoGPPack.IPackCollectionPublic}>(/public/motogpPackCollection).borrow()!
    return collection.getIDs()
}

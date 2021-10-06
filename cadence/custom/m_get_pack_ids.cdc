import NonFungibleToken from "../contracts/NonFungibleToken.cdc"
import MotoGPPack from "../contracts/MotoGPPack.cdc"

pub fun main(address: Address): [UInt64]? {
    let account = getAccount(address)
    let collection = getAccount(address).getCapability<&{MotoGPPack.IPackCollectionPublic}>(/public/motogpPackCollection).borrow()!
    return collection.getIDs()
}

import NonFungibleToken from "../../../../contracts/core/NonFungibleToken.cdc"
import TopShot from "../../../../contracts/third-party/TopShot.cdc"

// Take TopShot ids by account address
//
pub fun main(address: Address): [UInt64]? {
    let collection = getAccount(address)
        .getCapability(/public/MomentCollection)
        .borrow<&{TopShot.MomentCollectionPublic}>()
        ?? panic("NFT Collection not found")
    return collection.getIDs()
}
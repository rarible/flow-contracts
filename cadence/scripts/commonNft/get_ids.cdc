import NonFungibleToken from "../../contracts/NonFungibleToken.cdc"
import CommonNFT from "../../contracts/CommonNFT.cdc"

// Take CommonNFT ids by account address
//
pub fun main(address: Address): [UInt64]? {
    let collection = getAccount(address)
        .getCapability<&{NonFungibleToken.CollectionPublic}>(CommonNFT.collectionPublicPath)
        .borrow()
        ?? panic("NFT Collection not found")
    return collection.getIDs()
}

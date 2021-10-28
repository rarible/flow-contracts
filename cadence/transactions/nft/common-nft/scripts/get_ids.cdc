import NonFungibleToken from "../../../../contracts/core/NonFungibleToken.cdc"
import CommonNFT from "../../../../contracts/CommonNFT.cdc"

// Take CommonNFT ids by account address
//
pub fun main(address: Address): [UInt64]? {
    let collection = getAccount(address)
        .getCapability(CommonNFT.collectionPublicPath)
        .borrow<&{NonFungibleToken.CollectionPublic,NonFungibleToken.Receiver}>()
        ?? panic("NFT Collection not found")
    return collection.getIDs()
}
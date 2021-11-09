import NonFungibleToken from "../../../../contracts/core/NonFungibleToken.cdc"
import RaribleNFT from "../../../../contracts/RaribleNFT.cdc"

// Take RaribleNFT ids by account address
//
pub fun main(address: Address): [UInt64]? {
    let collection = getAccount(address)
        .getCapability(RaribleNFT.collectionPublicPath)
        .borrow<&{NonFungibleToken.CollectionPublic,NonFungibleToken.Receiver}>()
        ?? panic("NFT Collection not found")
    return collection.getIDs()
}
import NonFungibleToken from "../../../../contracts/core/NonFungibleToken.cdc"
import RaribleNFT from "../../../../contracts/RaribleNFT.cdc"

// Take RaribleNFT token props by account address and tokenId
//
pub fun main(address: Address, tokenId: UInt64): &AnyResource {
    let collection = getAccount(address)
        .getCapability<&{NonFungibleToken.CollectionPublic}>(RaribleNFT.collectionPublicPath)
        .borrow()
        ?? panic("NFT Collection not found")
    return collection.borrowNFT(id: tokenId)
}

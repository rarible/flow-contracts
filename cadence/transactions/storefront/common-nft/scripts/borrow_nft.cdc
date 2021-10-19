import NonFungibleToken from "../../../../contracts/core/NonFungibleToken.cdc"
import CommonNFT from "../../../../contracts/CommonNFT.cdc"

// Take CommonNFT token props by account address and tokenId
//
pub fun main(address: Address, tokenId: UInt64): &AnyResource {
    let collection = getAccount(address)
        .getCapability<&{NonFungibleToken.CollectionPublic}>(CommonNFT.collectionPublicPath)
        .borrow()
        ?? panic("NFT Collection not found")
    return collection.borrowNFT(id: tokenId)
}

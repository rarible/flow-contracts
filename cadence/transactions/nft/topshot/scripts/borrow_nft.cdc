import NonFungibleToken from "../../../../contracts/core/NonFungibleToken.cdc"
import TopShot from "../../../../contracts/third-party/TopShot.cdc"

// Take TopShot token props by account address and tokenId
//
pub fun main(address: Address, tokenId: UInt64): &AnyResource {
    let collection = getAccount(address)
        .getCapability(/public/MomentCollection)
        .borrow<&{TopShot.MomentCollectionPublic}>()
        ?? panic("NFT Collection not found")
    return collection.borrowNFT(id: tokenId)
}
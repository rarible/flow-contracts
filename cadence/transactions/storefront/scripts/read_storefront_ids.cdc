import NFTStorefront from "../../../contracts/core/NFTStorefront.cdc"

// This script returns an array of all the nft uuids for sale through a Storefront

pub fun main(address: Address): [UInt64] {
    let storefrontRef = getAccount(address)
        .getCapability<&NFTStorefront.Storefront{NFTStorefront.StorefrontPublic}>(
            NFTStorefront.StorefrontPublicPath
        )
        .borrow()
        ?? panic("Could not borrow public storefront from address")
    
    return storefrontRef.getListingIDs()
}

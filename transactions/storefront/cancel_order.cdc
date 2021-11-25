
import NFTStorefront from "../../../contracts/core/NFTStorefront.cdc"

transaction(orderId: UInt64) {

    let storefront: &NFTStorefront.Storefront{NFTStorefront.StorefrontPublic}

    prepare(acct: AuthAccount) {
        self.storefront = acct.getCapability(NFTStorefront.StorefrontPublicPath)!
            .borrow<&NFTStorefront.Storefront{NFTStorefront.StorefrontPublic}>()
            ?? panic("Could not borrow Storefront from provided address")
    }

    execute {
        self.storefront.removeListing(listingResourceID: orderId)
    }
}
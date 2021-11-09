import RaribleOrder from "../../contracts/RaribleOrder.cdc"
import NFTStorefront from "../../contracts/core/NFTStorefront.cdc"

transaction (orderId: UInt64) {
    let listing: &NFTStorefront.Listing{NFTStorefront.ListingPublic}
    let storefront: &NFTStorefront.Storefront
    let orderAddress: Address

    prepare(acct: AuthAccount) {
        self.storefront = acct.borrow<&NFTStorefront.Storefront>(from: NFTStorefront.StorefrontStoragePath)
            ?? panic("Missing or mis-typed NFTStorefront Storefront")

        self.listing = self.storefront.borrowListing(listingResourceID: orderId)
                    ?? panic("No Offer with that ID in Storefront")

        self.orderAddress = acct.address
    }

    execute {
        RaribleOrder.removeOrder(
            storefront: self.storefront,
            orderId: orderId,
            orderAddress: self.orderAddress,
            listing: self.listing,
        )
    }
}

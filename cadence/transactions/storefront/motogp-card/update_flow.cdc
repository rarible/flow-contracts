import MotoGPCard from "../../../contracts/third-party/MotoGPCard.cdc"
import CommonOrder from "../../../contracts/CommonOrder.cdc"
import FlowToken from "../../../contracts/core/FlowToken.cdc"
import FungibleToken from "../../../contracts/core/FungibleToken.cdc"
import NonFungibleToken from "../../../contracts/core/NonFungibleToken.cdc"
import NFTStorefront from "../../../contracts/core/NFTStorefront.cdc"

// Cancels order with [orderId], then open new order with same MotoGPCard token for FlowToken [price]
//
transaction(orderId: UInt64, price: UFix64) {
    let nftProvider: Capability<&MotoGPCard.Collection{NonFungibleToken.Provider, NonFungibleToken.CollectionPublic}>
    let storefront: &NFTStorefront.Storefront
    let listing: &NFTStorefront.Listing{NFTStorefront.ListingPublic}
    let orderAddress: Address

    prepare(acct: AuthAccount) {
        let nftProviderPath = /private/MotoGPCardProviderForNFTStorefront
        if !acct.getCapability<&MotoGPCard.Collection{NonFungibleToken.Provider, NonFungibleToken.CollectionPublic}>(nftProviderPath)!.check() {
            acct.link<&MotoGPCard.Collection{NonFungibleToken.Provider, NonFungibleToken.CollectionPublic}>(nftProviderPath, target: /storage/motogpCardCollection)
        }

        self.nftProvider = acct.getCapability<&MotoGPCard.Collection{NonFungibleToken.Provider, NonFungibleToken.CollectionPublic}>(nftProviderPath)!
        assert(self.nftProvider.borrow() != nil, message: "Missing or mis-typed nft collection provider")

        self.storefront = acct.borrow<&NFTStorefront.Storefront>(from: NFTStorefront.StorefrontStoragePath)
            ?? panic("Missing or mis-typed NFTStorefront Storefront")

        self.listing = self.storefront.borrowListing(listingResourceID: orderId)
            ?? panic("No Offer with that ID in Storefront")

        self.orderAddress = acct.address
    }

    execute {
        let royalties: [CommonOrder.PaymentPart] = []
        let extraCuts: [CommonOrder.PaymentPart] = []
        let details = self.listing.getDetails() 
        let tokenId = details.nftID
        
        
        CommonOrder.removeOrder(
            storefront: self.storefront,
            orderId: orderId,
            orderAddress: self.orderAddress,
            listing: self.listing,
        )

        CommonOrder.addOrder(
            storefront: self.storefront,
            nftProvider: self.nftProvider,
            nftType: details.nftType,
            nftId: details.nftID,
            vaultPath: /public/flowTokenReceiver,
            vaultType: Type<@FlowToken.Vault>(),
            price: price,
            extraCuts: extraCuts,
            royalties: royalties
        )
    }
}
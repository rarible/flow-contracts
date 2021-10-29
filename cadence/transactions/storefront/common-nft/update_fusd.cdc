import LicensedNFT from "../../../contracts/LicensedNFT.cdc"

import RaribleNFT from "../../../contracts/RaribleNFT.cdc"
import RaribleOrder from "../../../contracts/RaribleOrder.cdc"
import FUSD from "../../../contracts/core/FUSD.cdc"
import FungibleToken from "../../../contracts/core/FungibleToken.cdc"
import NonFungibleToken from "../../../contracts/core/NonFungibleToken.cdc"
import NFTStorefront from "../../../contracts/core/NFTStorefront.cdc"

// Cancels order with [orderId], then open new order with same RaribleNFT token for FUSD [price]
//
transaction(orderId: UInt64, price: UFix64) {
    let nftProvider: Capability<&{NonFungibleToken.Provider,NonFungibleToken.CollectionPublic,LicensedNFT.CollectionPublic}>
    let storefront: &NFTStorefront.Storefront
    let listing: &NFTStorefront.Listing{NFTStorefront.ListingPublic}
    let orderAddress: Address

    prepare(acct: AuthAccount) {
        let nftProviderPath = /private/RaribleNFTProviderForNFTStorefront
        if !acct.getCapability<&{NonFungibleToken.Provider,NonFungibleToken.CollectionPublic,LicensedNFT.CollectionPublic}>(nftProviderPath)!.check() {
            acct.link<&{NonFungibleToken.Provider,NonFungibleToken.CollectionPublic,LicensedNFT.CollectionPublic}>(nftProviderPath, target: RaribleNFT.collectionStoragePath)
        }

        self.nftProvider = acct.getCapability<&{NonFungibleToken.Provider,NonFungibleToken.CollectionPublic,LicensedNFT.CollectionPublic}>(nftProviderPath)!
        assert(self.nftProvider.borrow() != nil, message: "Missing or mis-typed nft collection provider")

        self.storefront = acct.borrow<&NFTStorefront.Storefront>(from: NFTStorefront.StorefrontStoragePath)
            ?? panic("Missing or mis-typed NFTStorefront Storefront")

        self.listing = self.storefront.borrowListing(listingResourceID: orderId)
            ?? panic("No Offer with that ID in Storefront")

        self.orderAddress = acct.address
    }

    execute {
        let royalties: [RaribleOrder.PaymentPart] = []
        let extraCuts: [RaribleOrder.PaymentPart] = []
        let details = self.listing.getDetails() 
        let tokenId = details.nftID
        
        for royalty in self.nftProvider.borrow()!.getRoyalties(id: tokenId) {
            royalties.append(RaribleOrder.PaymentPart(address: royalty.address, rate: royalty.fee))
        }
        
        
        RaribleOrder.removeOrder(
            storefront: self.storefront,
            orderId: orderId,
            orderAddress: self.orderAddress,
            listing: self.listing,
        )

        RaribleOrder.addOrder(
            storefront: self.storefront,
            nftProvider: self.nftProvider,
            nftType: details.nftType,
            nftId: details.nftID,
            vaultPath: /public/fusdReceiver,
            vaultType: Type<@FUSD.Vault>(),
            price: price,
            extraCuts: extraCuts,
            royalties: royalties
        )
    }
}
import FungibleToken from "../contracts/FungibleToken.cdc"
import NonFungibleToken from "../contracts/NonFungibleToken.cdc"
import FlowToken from "../contracts/FlowToken.cdc"
import TopShot from "../contracts/TopShot.cdc"
import NFTStorefront from "../contracts/NFTStorefront.cdc"

transaction(listingResourceID: UInt64, storefrontAddress: Address) {
    let paymentVault: @FungibleToken.Vault
    let collection: &{TopShot.MomentCollectionPublic}
    let storefront: &NFTStorefront.Storefront{NFTStorefront.StorefrontPublic}
    let listing: &NFTStorefront.Listing{NFTStorefront.ListingPublic}

    prepare(acct: AuthAccount) {
        let collectionPublicPath = /public/MomentCollection
        let collectionStoragePath = /storage/MomentCollection

        self.storefront = getAccount(storefrontAddress)
            .getCapability<&NFTStorefront.Storefront{NFTStorefront.StorefrontPublic}>(
                NFTStorefront.StorefrontPublicPath
            )!
            .borrow()
            ?? panic("Could not borrow Storefront from provided address")

        self.listing = self.storefront.borrowListing(listingResourceID: listingResourceID)
                    ?? panic("No Offer with that ID in Storefront")
        let price = self.listing.getDetails().salePrice

        let mainFlowVault = acct.borrow<&FlowToken.Vault>(from: /storage/flowTokenVault)
            ?? panic("Cannot borrow FlowToken vault from acct storage")
        self.paymentVault <- mainFlowVault.withdraw(amount: price)

        if acct.borrow<&TopShot.Collection>(from: collectionStoragePath) == nil {
            let collection <- TopShot.createEmptyCollection() as! @TopShot.Collection
            acct.save(<-collection, to: collectionStoragePath)
            acct.link<&{TopShot.MomentCollectionPublic}>(collectionPublicPath, target: collectionStoragePath)
        }

        self.collection = acct.getCapability<&{TopShot.MomentCollectionPublic}>(collectionPublicPath).borrow()
            ?? panic("Cannot borrow NFT collection receiver from account")
    }

    execute {
        let item <- self.listing.purchase(payment: <-self.paymentVault)
        self.collection.deposit(token: <-item)
        self.storefront.cleanup(listingResourceID: listingResourceID)
    }
}

import TopShot from "../../../contracts/third-party/TopShot.cdc"
import CommonOrder from "../../../contracts/CommonOrder.cdc"
import FlowToken from "../../../contracts/core/FlowToken.cdc"
import FungibleToken from "../../../contracts/core/FungibleToken.cdc"
import NFTStorefront from "../../../contracts/core/NFTStorefront.cdc"
import NonFungibleToken from "../../../contracts/core/NonFungibleToken.cdc"

transaction (orderId: UInt64, storefrontAddress: Address) {
    let listing: &NFTStorefront.Listing{NFTStorefront.ListingPublic}
    let paymentVault: @FungibleToken.Vault
    let storefront: &NFTStorefront.Storefront{NFTStorefront.StorefrontPublic}
    let tokenReceiver: &{TopShot.MomentCollectionPublic}
    let buyerAddress: Address

    prepare(acct: AuthAccount) {
        let collectionPublicPath = /public/MomentCollection
        let collectionStoragePath = /storage/MomentCollection

        self.storefront = getAccount(storefrontAddress)
            .getCapability(NFTStorefront.StorefrontPublicPath)!
            .borrow<&NFTStorefront.Storefront{NFTStorefront.StorefrontPublic}>()
            ?? panic("Could not borrow Storefront from provided address")

        self.listing = self.storefront.borrowListing(listingResourceID: orderId)
                    ?? panic("No Offer with that ID in Storefront")
        let price = self.listing.getDetails().salePrice

        let mainVault = acct.borrow<&FlowToken.Vault>(from: /storage/flowTokenVault)
            ?? panic("Cannot borrow FlowToken vault from acct storage")
        self.paymentVault <- mainVault.withdraw(amount: price)

        if acct.borrow<&TopShot.Collection>(from: collectionStoragePath) == nil {
            let collection <- TopShot.createEmptyCollection() as! @TopShot.Collection
            acct.save(<-collection, to: collectionStoragePath)
            acct.link<&{TopShot.MomentCollectionPublic}>(collectionPublicPath, target: collectionStoragePath)
        }

        self.tokenReceiver = acct.getCapability(collectionPublicPath)
            .borrow<&{TopShot.MomentCollectionPublic}>()
            ?? panic("Cannot borrow NFT collection receiver from account")

        self.buyerAddress = acct.address
    }

    execute {
        let item <- CommonOrder.closeOrder(
            storefront: self.storefront,
            orderId: orderId,
            orderAddress: storefrontAddress,
            listing: self.listing,
            paymentVault: <- self.paymentVault,
            buyerAddress: self.buyerAddress
        )
        self.tokenReceiver.deposit(token: <-item)
    }
}

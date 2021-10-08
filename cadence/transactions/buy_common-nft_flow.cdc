import FungibleToken from "../contracts/FungibleToken.cdc"
import NonFungibleToken from "../contracts/NonFungibleToken.cdc"
import FlowToken from "../contracts/FlowToken.cdc"
import CommonNFT from "../contracts/CommonNFT.cdc"
import NFTStorefront from "../contracts/NFTStorefront.cdc"

transaction(orderId: UInt64, storefrontAddress: Address) {
    let paymentVault: @FungibleToken.Vault
    let tokenReceiver: &{NonFungibleToken.Receiver}
    let storefront: &NFTStorefront.Storefront{NFTStorefront.StorefrontPublic}
    let listing: &NFTStorefront.Listing{NFTStorefront.ListingPublic}

    prepare(acct: AuthAccount) {
        self.storefront = getAccount(storefrontAddress)
            .getCapability<&NFTStorefront.Storefront{NFTStorefront.StorefrontPublic}>(
                NFTStorefront.StorefrontPublicPath
            )!
            .borrow()
            ?? panic("Could not borrow Storefront from provided address")

        self.listing = self.storefront.borrowListing(listingResourceID: orderId)
                    ?? panic("No Offer with that ID in Storefront")
        let price = self.listing.getDetails().salePrice

        let mainFlowVault = acct.borrow<&FlowToken.Vault>(from: /storage/flowTokenVault)
            ?? panic("Cannot borrow FlowToken vault from acct storage")
        self.paymentVault <- mainFlowVault.withdraw(amount: price)

        if acct.borrow<&CommonNFT.Collection>(from: CommonNFT.collectionStoragePath) == nil {
            let collection <- CommonNFT.createEmptyCollection() as! @CommonNFT.Collection
            acct.save(<- collection, to: CommonNFT.collectionStoragePath)
            acct.link<&{NonFungibleToken.CollectionPublic,NonFungibleToken.Receiver}>(CommonNFT.collectionPublicPath, target: CommonNFT.collectionStoragePath)
        }

        self.tokenReceiver = acct.getCapability<&{NonFungibleToken.Receiver}>(CommonNFT.collectionPublicPath).borrow()
            ?? panic("Cannot borrow NFT collection receiver from acct")
    }

    execute {
        let item <- self.listing.purchase(payment: <-self.paymentVault)
        self.tokenReceiver.deposit(token: <-item)
        self.storefront.cleanup(listingResourceID: orderId)
    }
}

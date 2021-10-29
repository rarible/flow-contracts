
import Evolution from "../../../contracts/third-party/Evolution.cdc"
import CommonOrder from "../../../contracts/CommonOrder.cdc"
import FUSD from "../../../contracts/core/FUSD.cdc"
import FungibleToken from "../../../contracts/core/FungibleToken.cdc"
import NFTStorefront from "../../../contracts/core/NFTStorefront.cdc"
import NonFungibleToken from "../../../contracts/core/NonFungibleToken.cdc"

// Buy Evolution token for FUSD with NFTStorefront
//
transaction (orderId: UInt64, storefrontAddress: Address) {
    let listing: &NFTStorefront.Listing{NFTStorefront.ListingPublic}
    let paymentVault: @FungibleToken.Vault
    let storefront: &NFTStorefront.Storefront{NFTStorefront.StorefrontPublic}
    let tokenReceiver: &{Evolution.EvolutionCollectionPublic}
    let buyerAddress: Address

    prepare(acct: AuthAccount) {
        self.storefront = getAccount(storefrontAddress)
            .getCapability(NFTStorefront.StorefrontPublicPath)!
            .borrow<&NFTStorefront.Storefront{NFTStorefront.StorefrontPublic}>()
            ?? panic("Could not borrow Storefront from provided address")

        self.listing = self.storefront.borrowListing(listingResourceID: orderId)
                    ?? panic("No Offer with that ID in Storefront")
        let price = self.listing.getDetails().salePrice

        let mainVault = acct.borrow<&FUSD.Vault>(from: /storage/fusdVault)
            ?? panic("Cannot borrow FUSD vault from acct storage")
        self.paymentVault <- mainVault.withdraw(amount: price)

        if acct.borrow<&Evolution.Collection>(from: /storage/f4264ac8f3256818_Evolution_Collection) == nil {
            let collection <- Evolution.createEmptyCollection() as! @Evolution.Collection
            acct.save(<-collection, to: /storage/f4264ac8f3256818_Evolution_Collection)
            acct.link<&{Evolution.EvolutionCollectionPublic}>(/public/f4264ac8f3256818_Evolution_Collection, target: /storage/f4264ac8f3256818_Evolution_Collection)
        }

        self.tokenReceiver = acct.getCapability(/public/f4264ac8f3256818_Evolution_Collection)
            .borrow<&{Evolution.EvolutionCollectionPublic}>()
            ?? panic("Cannot borrow NFT collection receiver from acct")

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
    
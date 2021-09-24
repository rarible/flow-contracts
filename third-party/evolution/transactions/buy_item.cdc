
import FungibleToken from "../contracts/FungibleToken.cdc"
import NonFungibleToken from "../contracts/NonFungibleToken.cdc"
import FlowToken from "../contracts/FlowToken.cdc"
import Evolution from "../contracts/Evolution.cdc"
import NFTStorefront from "../contracts/NFTStorefront.cdc"

transaction(saleOfferResourceID: UInt64, storefrontAddress: Address) {
    let paymentVault: @FungibleToken.Vault
    let collection: &{Evolution.EvolutionCollectionPublic}
    let storefront: &NFTStorefront.Storefront{NFTStorefront.StorefrontPublic}
    let saleOffer: &NFTStorefront.SaleOffer{NFTStorefront.SaleOfferPublic}

    prepare(acct: AuthAccount) {
        self.storefront = getAccount(storefrontAddress)
            .getCapability<&NFTStorefront.Storefront{NFTStorefront.StorefrontPublic}>(
                NFTStorefront.StorefrontPublicPath
            )!
            .borrow()
            ?? panic("Could not borrow Storefront from provided address")

        self.saleOffer = self.storefront.borrowSaleOffer(saleOfferResourceID: saleOfferResourceID)
                    ?? panic("No Offer with that ID in Storefront")
        let price = self.saleOffer.getDetails().salePrice

        let mainFlowVault = acct.borrow<&FlowToken.Vault>(from: /storage/flowTokenVault)
            ?? panic("Cannot borrow FlowToken vault from acct storage")
        self.paymentVault <- mainFlowVault.withdraw(amount: price)

        if acct.borrow<&Evolution.Collection>(from: /storage/f4264ac8f3256818_Evolution_Collection) == nil {
            let collection <- Evolution.createEmptyCollection() as! @Evolution.Collection
            acct.save(<-collection, to: /storage/f4264ac8f3256818_Evolution_Collection)
            acct.link<&{Evolution.EvolutionCollectionPublic}>(/public/f4264ac8f3256818_Evolution_Collection, target: /storage/f4264ac8f3256818_Evolution_Collection)
        }

        self.collection = acct.getCapability<&{Evolution.EvolutionCollectionPublic}>(/public/f4264ac8f3256818_Evolution_Collection).borrow()
            ?? panic("Cannot borrow NFT collection receiver from account")
    }

    execute {
        let item <- self.saleOffer.accept(payment: <-self.paymentVault)
        self.collection.deposit(token: <-item)
        self.storefront.cleanup(saleOfferResourceID: saleOfferResourceID)
    }
}

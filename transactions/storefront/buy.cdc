import RaribleNFT from "../../contracts/RaribleNFT.cdc" //template (NFT)
import FlowToken from "../../contracts/core/FlowToken.cdc" //template (vault Type)
import FungibleToken from "../../contracts/core/FungibleToken.cdc"
import NFTStorefront from "../../contracts/core/NFTStorefront.cdc"
import NonFungibleToken from "../../contracts/core/NonFungibleToken.cdc"

/*
 * Buy item
 * 
 */
transaction(orderId: UInt64, storefrontAddress: Address, fees: {Address: UFix64}) {
    let paymentVault: @FungibleToken.Vault
    let feeVault: @FungibleToken.Vault
    let storefront: &NFTStorefront.Storefront{NFTStorefront.StorefrontPublic}
    let tokenReceiver: &{NonFungibleToken.Receiver}
    let feePayments: {Address: UFix64}

    prepare(acct: AuthAccount) {
        self.storefront = getAccount(storefrontAddress)
            .getCapability(NFTStorefront.StorefrontPublicPath)!
            .borrow<&NFTStorefront.Storefront{NFTStorefront.StorefrontPublic}>()
            ?? panic("Could not borrow Storefront from provided address")

        let listing = self.storefront.borrowListing(listingResourceID: orderId)
                    ?? panic("No Offer with that ID in Storefront")
        let price = self.listing.getDetails().salePrice
        var feesAmount = 0.0
        let vaultPath = /public/flowTokenReceiver //template


        for k in fees.keys {
            let amount = price * fees[k]
            self.feePayments.insert(key: k, amount)
            feesAmount = feesAmount + amount
        }

        let protocolFee = price * RaribleFee.buyerFee()
        self.feePayments.insert(key: RaribleFee.feeAddress(), protocolFee)
        feesAmount = feesAmount + protocolFee
        
        let mainVault = acct.borrow<&FlowToken.Vault>(from: /storage/flowTokenVault) //template
            ?? panic("Cannot borrow FlowToken vault from acct storage")
        self.paymentVault <- mainVault.withdraw(amount: price)
        self.feeVault <- mainVault.withdraw(amount: feesAmount)

        if acct.borrow<&RaribleNFT.Collection>(from: RaribleNFT.collectionStoragePath /* template */) == nil {
            let collection <- RaribleNFT.createEmptyCollection() as! @RaribleNFT.Collection // template
            acct.save(<-collection, to: RaribleNFT.collectionStoragePath) // template
            acct.link<&{NonFungibleToken.CollectionPublic,NonFungibleToken.Receiver}>(RaribleNFT.collectionPublicPath, target: RaribleNFT.collectionStoragePath) //template
        }

        self.tokenReceiver = acct.getCapability(RaribleNFT.collectionPublicPath)
            .borrow<&{NonFungibleToken.Receiver}>()
            ?? panic("Cannot borrow NFT collection receiver from acct")
    }

    execute {

        // pay fee's
        for k in self.feePayments.keys {
            let receiver = getAccount(k).getCapability<&{FungibleToken.Receiver}>().borrow() ?? panic("Can't borrow receiver for fee payment")
            let payment <- self.feeVault.withdraw(amount: self.feePayments[k])
            receiver.deposit(from: <- payment)
        }

        // purchase item
        let item <- self.storefront.purchase(payment: <- self.paymentVault)
        // transfer item to buyer
        self.tokenReceiver.deposit(token: <- item)
    }
}

export const commonNftScripts = {
	borrow_nft: `
import CommonNFT from 0xCOMMONNFT

pub fun main(address: Address, tokenId: UInt64): &AnyResource {
    let account = getAccount(address)
    let collection = CommonNFT.collectionPublic(address).borrow()!
    return collection.borrowNFT(id: tokenId)
}
	`,

	check: `
import CommonNFT from 0xCOMMONNFT

pub fun main(address: Address): Bool {
    return CommonNFT.receiver(address).check()
}
	`,

	get_ids: `
import CommonNFT from 0xCOMMONNFT

pub fun main(address: Address): [UInt64]? {
    let account = getAccount(address)
    let collection = CommonNFT.collectionPublic(address).borrow()!
    return collection.getIDs()
}
	`,
}
export const commonNftTransactions = {
	burn: `
import NonFungibleToken from 0xNONFUNGIBLETOKEN
import CommonNFT from 0xCOMMONNFT

transaction(tokenId: UInt64) {
    prepare(account: AuthAccount) {
        if account.borrow<&CommonNFT.Collection>(from: CommonNFT.collectionStoragePath) == nil {
            let collection <- CommonNFT.createEmptyCollection() as! @CommonNFT.Collection
            account.save(<- collection, to: CommonNFT.collectionStoragePath)
            account.link<&{NonFungibleToken.CollectionPublic,NonFungibleToken.Receiver}>(CommonNFT.collectionPublicPath, target: CommonNFT.collectionStoragePath)
        }
        let collection = account.borrow<&CommonNFT.Collection>(from: CommonNFT.collectionStoragePath)!
        destroy collection.withdraw(withdrawID: tokenId)
    }
}
	`,

	clean: `
import CommonNFT from 0xCOMMONNFT

transaction {
    prepare(account: AuthAccount) {
        account.unlink(CommonNFT.collectionPublicPath)
        destroy <- account.load<@Collection>(from: CommonNFT.collectionStoragePath)
    }
}
	`,

	init: `
import NonFungibleToken from 0xNONFUNGIBLETOKEN
import CommonNFT from 0xCOMMONNFT

transaction {
    prepare(account: AuthAccount) {
        if account.borrow<&CommonNFT.Collection>(from: CommonNFT.collectionStoragePath) == nil {
            let collection <- CommonNFT.createEmptyCollection() as! @CommonNFT.Collection
            account.save(<- collection, to: CommonNFT.collectionStoragePath)
            account.link<&{NonFungibleToken.CollectionPublic,NonFungibleToken.Receiver}>(CommonNFT.collectionPublicPath, target: CommonNFT.collectionStoragePath)
        }
    }
}
	`,

	mint: `
import NonFungibleToken from 0xNONFUNGIBLETOKEN
import CommonNFT from 0xCOMMONNFT

transaction(metadata: String, royalties: [CommonNFT.Royalties]) {
    let minter: Capability<&CommonNFT.Minter>
    let receiver: Capability<&{NonFungibleToken.Receiver}>

    prepare(account: AuthAccount) {
        if account.borrow<&CommonNFT.Collection>(from: CommonNFT.collectionStoragePath) == nil {
            let collection <- CommonNFT.createEmptyCollection() as! @CommonNFT.Collection
            account.save(<- collection, to: CommonNFT.collectionStoragePath)
            account.link<&{NonFungibleToken.CollectionPublic,NonFungibleToken.Receiver}>(CommonNFT.collectionPublicPath, target: CommonNFT.collectionStoragePath)
        }

        self.minter = CommonNFT.minter()
        self.receiver = CommonNFT.receiver(account.address)
    }

    execute {
        let minter = self.minter.borrow() ?? panic("Could not borrow receiver capability (maybe receiver not configured?)")
        minter.mintTo(creator: self.receiver, metadata: metadata, royalties: royalties)
    }
}
	`,

	mrproper: `
import NonFungibleToken from 0xNONFUNGIBLETOKEN
import CommonNFT from 0xCOMMONNFT

transaction {
    prepare(account: AuthAccount) {
        account.unlink(self.minterPublicPath)
        destroy <- account.load<@AnyResource>(from: self.minterStoragePath)

        account.unlink(self.collectionPublicPath)
        destroy <- account.load<@AnyResource>(from: self.collectionStoragePath)
    }
}
	`,

	transfer: `
import NonFungibleToken from 0xNONFUNGIBLETOKEN
import CommonNFT from 0xCOMMONNFT

transaction(tokenId: UInt64, to: Address) {
    prepare(account: AuthAccount) {
        if account.borrow<&CommonNFT.Collection>(from: CommonNFT.collectionStoragePath) == nil {
            let collection <- CommonNFT.createEmptyCollection() as! @CommonNFT.Collection
            account.save(<- collection, to: CommonNFT.collectionStoragePath)
            account.link<&{NonFungibleToken.CollectionPublic,NonFungibleToken.Receiver}>(CommonNFT.collectionPublicPath, target: CommonNFT.collectionStoragePath)
        }
        let collection = account.borrow<&CommonNFT.Collection>(from: CommonNFT.collectionStoragePath)!
        collection.transfer(tokenId: tokenId, to: CommonNFT.receiver(to))
    }
}
	`,
}
export const nftStorefrontScripts = {
	get_fees: `
import CommonFee from 0xCOMMONFEE

pub fun main(): {String:UFix64} {
    return {
        "buyerFee": CommonFee.buyerFee,
        "sellerFee": CommonFee.sellerFee
    }
}
	`,

	read_listing_details: `
import NFTStorefront from 0xNFTSTOREFRONT

// This script returns the details for a sale offer within a storefront

pub fun main(account: Address, saleOfferResourceID: UInt64): NFTStorefront.SaleOfferDetails {
    let storefrontRef = getAccount(account)
        .getCapability<&NFTStorefront.Storefront{NFTStorefront.StorefrontPublic}>(
            NFTStorefront.StorefrontPublicPath
        )
        .borrow()
        ?? panic("Could not borrow public storefront from address")

    let saleOffer = storefrontRef.borrowSaleOffer(saleOfferResourceID: saleOfferResourceID)
        ?? panic("No item with that ID")
    
    return saleOffer.getDetails()
}
	`,

	read_storefront_ids: `
import NFTStorefront from 0xNFTSTOREFRONT

// This script returns an array of all the nft uuids for sale through a Storefront

pub fun main(account: Address): [UInt64] {
    let storefrontRef = getAccount(account)
        .getCapability<&NFTStorefront.Storefront{NFTStorefront.StorefrontPublic}>(
            NFTStorefront.StorefrontPublicPath
        )
        .borrow()
        ?? panic("Could not borrow public storefront from address")
    
    return storefrontRef.getSaleOfferIDs()
}
 	`,
}
export const nftStorefrontTransactions = {
	buy_item: `
import FungibleToken from 0xFUNGIBLETOKEN
import NonFungibleToken from 0xNONFUNGIBLETOKEN
import FlowToken from 0xFLOWTOKEN
import CommonNFT from 0xCOMMONNFT
import NFTStorefront from 0xNFTSTOREFRONT

transaction(saleOfferResourceID: UInt64, storefrontAddress: Address) {
    let paymentVault: @FungibleToken.Vault
    let commonNFTCollection: &{NonFungibleToken.Receiver}
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

        self.commonNFTCollection = CommonNFT.receiver(acct.address).borrow()
            ?? panic("Cannot borrow NFT collection receiver from account")
    }

    execute {
        let item <- self.saleOffer.accept(
            payment: <-self.paymentVault
        )

        self.commonNFTCollection.deposit(token: <-item)

        /* //-
        error: Execution failed:
        computation limited exceeded: 100
        */
        // Be kind and recycle
        self.storefront.cleanup(saleOfferResourceID: saleOfferResourceID)
    }

    //- Post to check item is in collection?
}
	`,

	cleanup_item: `
import NFTStorefront from 0xNFTSTOREFRONT

transaction(saleOfferResourceID: UInt64, storefrontAddress: Address) {
    let storefront: &NFTStorefront.Storefront{NFTStorefront.StorefrontPublic}

    prepare(acct: AuthAccount) {
        self.storefront = getAccount(storefrontAddress)
            .getCapability<&NFTStorefront.Storefront{NFTStorefront.StorefrontPublic}>(
                NFTStorefront.StorefrontPublicPath
            )!
            .borrow()
            ?? panic("Could not borrow Storefront from provided address")
    }

    execute {
        // Be kind and recycle
        self.storefront.cleanup(saleOfferResourceID: saleOfferResourceID)
    }
}
	`,

	remove_item: `
import NFTStorefront from 0xNFTSTOREFRONT

transaction(saleOfferResourceID: UInt64) {
    let storefront: &NFTStorefront.Storefront{NFTStorefront.StorefrontManager}

    prepare(acct: AuthAccount) {
        self.storefront = acct.borrow<&NFTStorefront.Storefront{NFTStorefront.StorefrontManager}>(from: NFTStorefront.StorefrontStoragePath)
            ?? panic("Missing or mis-typed NFTStorefront.Storefront")
    }

    execute {
        self.storefront.removeSaleOffer(saleOfferResourceID: saleOfferResourceID)
    }
}	`,

	sell_item: `
import FungibleToken from 0xFUNGIBLETOKEN
import NonFungibleToken from 0xNONFUNGIBLETOKEN
import FlowToken from 0xFLOWTOKEN
import CommonNFT from 0xCOMMONNFT
import NFTStorefront from 0xNFTSTOREFRONT
import CommonFee from 0xCOMMONFEE
import NFTPlus from 0xNFTPLUS

/**
 * Sell CommonNFT token for Flow with NFTStorefront
 *
 * @params saleItemID CommonNFT token ID
 * @params saleItemPrice price in Flow
 */
transaction(saleItemID: UInt64, saleItemPrice: UFix64) {
    let nftProvider: Capability<&CommonNFT.Collection{NonFungibleToken.Provider, NonFungibleToken.CollectionPublic, NFTPlus.CollectionPublic}>
    let storefront: &NFTStorefront.Storefront

    prepare(acct: AuthAccount) {
        let commonNFTCollectionProviderPrivatePath = /private/commonNFTCollectionProviderForNFTStorefront

        if !acct.getCapability<&CommonNFT.Collection{NonFungibleToken.Provider, NonFungibleToken.CollectionPublic, NFTPlus.CollectionPublic}>(commonNFTCollectionProviderPrivatePath)!.check() {
            acct.link<&CommonNFT.Collection{NonFungibleToken.Provider, NonFungibleToken.CollectionPublic, NFTPlus.CollectionPublic}>(commonNFTCollectionProviderPrivatePath, target: CommonNFT.collectionStoragePath)
        }

        self.nftProvider = acct.getCapability<&CommonNFT.Collection{NonFungibleToken.Provider, NonFungibleToken.CollectionPublic, NFTPlus.CollectionPublic}>(commonNFTCollectionProviderPrivatePath)!
        assert(self.nftProvider.borrow() != nil, message: "Missing or mis-typed CommonNFT.Collection provider")

        if acct.borrow<&NFTStorefront.Storefront>(from: NFTStorefront.StorefrontStoragePath) == nil {
            let storefront <- NFTStorefront.createStorefront() as! @NFTStorefront.Storefront
            acct.save(<-storefront, to: NFTStorefront.StorefrontStoragePath)
            acct.link<&NFTStorefront.Storefront{NFTStorefront.StorefrontPublic}>(NFTStorefront.StorefrontPublicPath, target: NFTStorefront.StorefrontStoragePath)
        }

        self.storefront = acct.borrow<&NFTStorefront.Storefront>(from: NFTStorefront.StorefrontStoragePath)
            ?? panic("Missing or mis-typed NFTStorefront Storefront")
    }

    execute {
        // effective price: itemPrice + buyerFee
        var rest = saleItemPrice * (100.0 + CommonFee.buyerFee) / 100.0

        // create sale cut
        let createCut = fun (_ address: Address, _ amount: UFix64): NFTStorefront.SaleCut {
            let receiver = getAccount(address).getCapability<&{FungibleToken.Receiver}>(/public/flowTokenReceiver)
            assert(receiver.borrow() != nil, message: "Missing or mis-typed FlowToken receiver")
            rest = rest - amount
            return NFTStorefront.SaleCut(receiver: receiver, amount: amount)
        }

        // add fees
        let saleCuts = [
            createCut(CommonFee.feeAddress(), saleItemPrice * CommonFee.buyerFee / 100.0),
            createCut(CommonFee.feeAddress(), saleItemPrice * CommonFee.sellerFee / 100.0)
        ]

        // add royalty
        for royalty in self.nftProvider.borrow()!.getRoyalties(id: saleItemID) {
            saleCuts.append(createCut(royalty.address, saleItemPrice * royalty.fee / 100.0))
        }

        // add seller
        saleCuts.append(createCut(self.nftProvider.address, rest))

        self.storefront.createSaleOffer(
            nftProviderCapability: self.nftProvider,
            nftType: Type<@CommonNFT.NFT>(),
            nftID: saleItemID,
            salePaymentVaultType: Type<@FlowToken.Vault>(),
            saleCuts: saleCuts
        )
    }
}
	`,

	set_fees: `
import CommonFee from 0xCOMMONFEE

transaction (sellerFee: UFix64, buyerFee: UFix64) {
    let manager: &CommonFee.Manager

    prepare (account: AuthAccount) {
        self.manager = account.borrow<&CommonFee.Manager>(from: CommonFee.commonFeeManagerStoragePath)
            ?? panic("Could not borrow fee manager")
    }

    execute {
        self.manager.setSellerFee(sellerFee)
        self.manager.setBuyerFee(buyerFee)
    }
}
	`,

	setup_account: `
import NFTStorefront from 0xNFTSTOREFRONT

// This transaction installs the Storefront ressource in an account.

transaction {
    prepare(acct: AuthAccount) {

        // If the account doesn't already have a Storefront
        if acct.borrow<&NFTStorefront.Storefront>(from: NFTStorefront.StorefrontStoragePath) == nil {

            // Create a new empty .Storefront
            let storefront <- NFTStorefront.createStorefront() as! @NFTStorefront.Storefront
            
            // save it to the account
            acct.save(<-storefront, to: NFTStorefront.StorefrontStoragePath)

            // create a public capability for the .Storefront
            acct.link<&NFTStorefront.Storefront{NFTStorefront.StorefrontPublic}>(NFTStorefront.StorefrontPublicPath, target: NFTStorefront.StorefrontStoragePath)
        }
    }
}
	`,
}
import FungibleToken from "../../contracts/FungibleToken.cdc"
import NonFungibleToken from "../../contracts/NonFungibleToken.cdc"
import FlowToken from "../../contracts/FlowToken.cdc"
import CommonNFT from "../../contracts/CommonNFT.cdc"
import NFTStorefront from "../../contracts/NFTStorefront.cdc"
import CommonFee from "../../contracts/CommonFee.cdc"
import NFTPlus from "../../contracts/NFTPlus.cdc"

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

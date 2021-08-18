import FungibleToken from 0xFUNGIBLETOKEN
import NonFungibleToken from 0xNONFUNGIBLETOKEN
import FlowToken from 0xFLOWTOKEN
import CommonNFT from 0xCOMMONNFT
import NFTStorefront from 0xNFTSTOREFRONT
import CommonFee from 0xCOMMONFEE

/**
 * Sell CommonNFT token for Flow with NFTStorefront
 *
 * @params saleItemID CommonNFT token ID
 * @params saleItemPrice price in Flow
 */
transaction(saleItemID: UInt64, saleItemPrice: UFix64) {
    let flowReceiver: Capability<&FlowToken.Vault{FungibleToken.Receiver}>
    let nftProvider: Capability<&CommonNFT.Collection{NonFungibleToken.Provider, NonFungibleToken.CollectionPublic}>
    let storefront: &NFTStorefront.Storefront

    prepare(acct: AuthAccount) {
        let commonNFTCollectionProviderPrivatePath = /private/exampleNFTCollectionProviderForNFTStorefront

        self.flowReceiver = acct.getCapability<&FlowToken.Vault{FungibleToken.Receiver}>(/public/flowTokenReceiver)!
        assert(self.flowReceiver.borrow() != nil, message: "Missing or mis-typed FlowToken receiver")

        if !acct.getCapability<&CommonNFT.Collection{NonFungibleToken.Provider, NonFungibleToken.CollectionPublic}>(commonNFTCollectionProviderPrivatePath)!.check() {
            acct.link<&CommonNFT.Collection{NonFungibleToken.Provider, NonFungibleToken.CollectionPublic}>(commonNFTCollectionProviderPrivatePath, target: CommonNFT.collectionStoragePath)
        }

        self.nftProvider = acct.getCapability<&CommonNFT.Collection{NonFungibleToken.Provider, NonFungibleToken.CollectionPublic}>(commonNFTCollectionProviderPrivatePath)!
        assert(self.nftProvider.borrow() != nil, message: "Missing or mis-typed CommonNFT.Collection provider")
        // self.nftProvider = acct.borrow<&CommonNFT.Collection{NonFungibleToken.Provider,NonFungibleToken.CollectionPublic}>(from: CommonNFT.collectionStoragePath)
            // ?? panic("Missing CommonNFT collection")

        self.storefront = acct.borrow<&NFTStorefront.Storefront>(from: NFTStorefront.StorefrontStoragePath)
            ?? panic("Missing or mis-typed NFTStorefront Storefront")
    }

    execute {
        let feeReceiver = getAccount(CommonFee.feeAddress()).getCapability<&{FungibleToken.Receiver}>(/public/flowTokenReceiver)!
        let saleCuts = [
            NFTStorefront.SaleCut(
                receiver: feeReceiver,
                amount: saleItemPrice * CommonFee.sellerFee / 100.0
            ),
            NFTStorefront.SaleCut(
                receiver: feeReceiver,
                amount: saleItemPrice * CommonFee.buyerFee / 100.0
            ),
            NFTStorefront.SaleCut(
                receiver: self.flowReceiver,
                amount: saleItemPrice * (100.0 - CommonFee.buyerFee - CommonFee.sellerFee) / 100.0
            )
        ]
        // let ref = self.nftProvider.borrow()!.borrowNFT(id: saleItemID) as! &CommonNFT.NFT
        // for ref. in  {
            
        // }
        self.storefront.createSaleOffer(
            nftProviderCapability: self.nftProvider,
            nftType: Type<@CommonNFT.NFT>(),
            nftID: saleItemID,
            salePaymentVaultType: Type<@FlowToken.Vault>(),
            saleCuts: saleCuts
        )
    }
}

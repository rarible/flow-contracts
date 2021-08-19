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

        // base for royalties
        let base = saleItemPrice * (100.0 - CommonFee.sellerFee) / 100.0

        // add fees
        let saleCuts = [
            createCut(CommonFee.feeAddress(), saleItemPrice * CommonFee.buyerFee / 100.0),
            createCut(CommonFee.feeAddress(), saleItemPrice * CommonFee.sellerFee / 100.0)
        ]

        // add royalty
        for royalty in self.nftProvider.borrow()!!.getRoyalties(id: saleItemID) {
            saleCuts.append(createCut(royalty.address, base * royalty.fee / 100.0))
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

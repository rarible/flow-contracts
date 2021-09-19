import FungibleToken from "../contracts/FungibleToken.cdc"
import NonFungibleToken from "../contracts/NonFungibleToken.cdc"
import FlowToken from "../contracts/FlowToken.cdc"
import NFTStorefront from "../contracts/NFTStorefront.cdc"
import CommonFee from "../contracts/CommonFee.cdc"
import MotoGPPack from "../contracts/MotoGPPack.cdc"

transaction(saleItemID: UInt64, saleItemPrice: UFix64) {
    let nftProvider: Capability<&MotoGPPack.Collection{NonFungibleToken.Provider, NonFungibleToken.CollectionPublic}>
    let storefront: &NFTStorefront.Storefront

    prepare(acct: AuthAccount) {
        let motoGpPackCollectionProviderPrivatePath = /private/motoGpPackCollectionProviderForNFTStorefront

        if !acct.getCapability<&MotoGPPack.Collection{NonFungibleToken.Provider, NonFungibleToken.CollectionPublic}>(motoGpPackCollectionProviderPrivatePath)!.check() {
            acct.link<&MotoGPPack.Collection{NonFungibleToken.Provider, NonFungibleToken.CollectionPublic}>(motoGpPackCollectionProviderPrivatePath, target: /storage/motogpPackCollection)
        }

        self.nftProvider = acct.getCapability<&MotoGPPack.Collection{NonFungibleToken.Provider, NonFungibleToken.CollectionPublic}>(motoGpPackCollectionProviderPrivatePath)!
        assert(self.nftProvider.borrow() != nil, message: "Missing or mis-typed MotoGPPack.Collection provider")

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

        // add seller
        saleCuts.append(createCut(self.nftProvider.address, rest))

        self.storefront.createSaleOffer(
            nftProviderCapability: self.nftProvider,
            nftType: Type<@MotoGPPack.NFT>(),
            nftID: saleItemID,
            salePaymentVaultType: Type<@FlowToken.Vault>(),
            saleCuts: saleCuts
        )
    }
}

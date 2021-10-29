import RaribleFee from "../../../contracts/RaribleFee.cdc"
import TopShot from "../../../contracts/third-party/TopShot.cdc"
import RaribleOrder from "../../../contracts/RaribleOrder.cdc"
import FlowToken from "../../../contracts/core/FlowToken.cdc"
import FungibleToken from "../../../contracts/core/FungibleToken.cdc"
import NonFungibleToken from "../../../contracts/core/NonFungibleToken.cdc"
import NFTStorefront from "../../../contracts/core/NFTStorefront.cdc"

// Sell TopShot token for FlowToken with NFTStorefront
//
transaction(tokenId: UInt64, price: UFix64) {
    let nftProvider: Capability<&TopShot.Collection{NonFungibleToken.Provider, NonFungibleToken.CollectionPublic}>
    let storefront: &NFTStorefront.Storefront

    prepare(acct: AuthAccount) {
        let nftProviderPath = /private/TopShotProviderForNFTStorefront
        if !acct.getCapability<&TopShot.Collection{NonFungibleToken.Provider, NonFungibleToken.CollectionPublic}>(nftProviderPath)!.check() {
            acct.link<&TopShot.Collection{NonFungibleToken.Provider, NonFungibleToken.CollectionPublic}>(nftProviderPath, target: /storage/MomentCollection)
        }

        self.nftProvider = acct.getCapability<&TopShot.Collection{NonFungibleToken.Provider, NonFungibleToken.CollectionPublic}>(nftProviderPath)!
        assert(self.nftProvider.borrow() != nil, message: "Missing or mis-typed nft collection provider")

        if acct.borrow<&NFTStorefront.Storefront>(from: NFTStorefront.StorefrontStoragePath) == nil {
            let storefront <- NFTStorefront.createStorefront() as! @NFTStorefront.Storefront
            acct.save(<-storefront, to: NFTStorefront.StorefrontStoragePath)
            acct.link<&NFTStorefront.Storefront{NFTStorefront.StorefrontPublic}>(NFTStorefront.StorefrontPublicPath, target: NFTStorefront.StorefrontStoragePath)
        }
        self.storefront = acct.borrow<&NFTStorefront.Storefront>(from: NFTStorefront.StorefrontStoragePath)
            ?? panic("Missing or mis-typed NFTStorefront Storefront")
    }

    execute {
        let royalties: [RaribleOrder.PaymentPart] = []
        let extraCuts: [RaribleOrder.PaymentPart] = []
        
        
        extraCuts.append(RaribleOrder.PaymentPart(address: RaribleFee.feeAddress(), rate: 0.05))
        
        RaribleOrder.addOrder(
            storefront: self.storefront,
            nftProvider: self.nftProvider,
            nftType: Type<@TopShot.NFT>(),
            nftId: tokenId,
            vaultPath: /public/flowTokenReceiver,
            vaultType: Type<@FlowToken.Vault>(),
            price: price,
            extraCuts: extraCuts,
            royalties: royalties
        )
    }
}
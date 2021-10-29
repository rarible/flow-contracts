import MotoGPCard from "../../../contracts/third-party/MotoGPCard.cdc"
import RaribleOrder from "../../../contracts/RaribleOrder.cdc"
import FlowToken from "../../../contracts/core/FlowToken.cdc"
import FungibleToken from "../../../contracts/core/FungibleToken.cdc"
import NonFungibleToken from "../../../contracts/core/NonFungibleToken.cdc"
import NFTStorefront from "../../../contracts/core/NFTStorefront.cdc"

// Sell MotoGPCard token for FlowToken with NFTStorefront
//
transaction(tokenId: UInt64, price: UFix64) {
    let nftProvider: Capability<&MotoGPCard.Collection{NonFungibleToken.Provider, NonFungibleToken.CollectionPublic}>
    let storefront: &NFTStorefront.Storefront

    prepare(acct: AuthAccount) {
        let nftProviderPath = /private/MotoGPCardProviderForNFTStorefront
        if !acct.getCapability<&MotoGPCard.Collection{NonFungibleToken.Provider, NonFungibleToken.CollectionPublic}>(nftProviderPath)!.check() {
            acct.link<&MotoGPCard.Collection{NonFungibleToken.Provider, NonFungibleToken.CollectionPublic}>(nftProviderPath, target: /storage/motogpCardCollection)
        }

        self.nftProvider = acct.getCapability<&MotoGPCard.Collection{NonFungibleToken.Provider, NonFungibleToken.CollectionPublic}>(nftProviderPath)!
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
        
        
        RaribleOrder.addOrder(
            storefront: self.storefront,
            nftProvider: self.nftProvider,
            nftType: Type<@MotoGPCard.NFT>(),
            nftId: tokenId,
            vaultPath: /public/flowTokenReceiver,
            vaultType: Type<@FlowToken.Vault>(),
            price: price,
            extraCuts: extraCuts,
            royalties: royalties
        )
    }
}
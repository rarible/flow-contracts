import LicensedNFT from "../../../contracts/LicensedNFT.cdc"

import RaribleNFT from "../../../contracts/RaribleNFT.cdc"
import RaribleOrder from "../../../contracts/RaribleOrder.cdc"
import FUSD from "../../../contracts/core/FUSD.cdc"
import FungibleToken from "../../../contracts/core/FungibleToken.cdc"
import NonFungibleToken from "../../../contracts/core/NonFungibleToken.cdc"
import NFTStorefront from "../../../contracts/core/NFTStorefront.cdc"

// Sell RaribleNFT token for FUSD with NFTStorefront
//
transaction(tokenId: UInt64, price: UFix64) {
    let nftProvider: Capability<&{NonFungibleToken.Provider,NonFungibleToken.CollectionPublic,LicensedNFT.CollectionPublic}>
    let storefront: &NFTStorefront.Storefront

    prepare(acct: AuthAccount) {
        let nftProviderPath = /private/RaribleNFTProviderForNFTStorefront
        if !acct.getCapability<&{NonFungibleToken.Provider,NonFungibleToken.CollectionPublic,LicensedNFT.CollectionPublic}>(nftProviderPath)!.check() {
            acct.link<&{NonFungibleToken.Provider,NonFungibleToken.CollectionPublic,LicensedNFT.CollectionPublic}>(nftProviderPath, target: RaribleNFT.collectionStoragePath)
        }

        self.nftProvider = acct.getCapability<&{NonFungibleToken.Provider,NonFungibleToken.CollectionPublic,LicensedNFT.CollectionPublic}>(nftProviderPath)!
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
        
        for royalty in self.nftProvider.borrow()!.getRoyalties(id: tokenId) {
            royalties.append(RaribleOrder.PaymentPart(address: royalty.address, rate: royalty.fee))
        }
        
        
        RaribleOrder.addOrder(
            storefront: self.storefront,
            nftProvider: self.nftProvider,
            nftType: Type<@RaribleNFT.NFT>(),
            nftId: tokenId,
            vaultPath: /public/fusdReceiver,
            vaultType: Type<@FUSD.Vault>(),
            price: price,
            extraCuts: extraCuts,
            royalties: royalties
        )
    }
}
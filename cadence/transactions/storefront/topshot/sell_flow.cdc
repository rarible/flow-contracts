import NonFungibleToken from "../../../contracts/core/NonFungibleToken.cdc"
import FlowToken from "../../../contracts/core/FlowToken.cdc"
import NFTStorefront from "../../../contracts/core/NFTStorefront.cdc"
import RaribleOrder from "../../../contracts/RaribleOrder.cdc"
import TopShot from "../../../contracts/third-party/TopShot.cdc"
import RaribleFee from "../../../contracts/RaribleFee.cdc"

// Sell TopShot moment for Flow with NFTStorefront
//
transaction(tokenId: UInt64, price: UFix64) {
    let nftProvider: Capability<&TopShot.Collection{NonFungibleToken.Provider, NonFungibleToken.CollectionPublic}>
    let storefront: &NFTStorefront.Storefront

    prepare(acct: AuthAccount) {
        let collectionStoragePath = /storage/MomentCollection

        let nftProviderPath = /private/TopShotCollectionProviderForNFTStorefront
        if !acct.getCapability<&TopShot.Collection{NonFungibleToken.Provider, NonFungibleToken.CollectionPublic}>(nftProviderPath)!.check() {
            acct.link<&TopShot.Collection{NonFungibleToken.Provider, NonFungibleToken.CollectionPublic}>(nftProviderPath, target: collectionStoragePath)
        }
        self.nftProvider = acct.getCapability<&TopShot.Collection{NonFungibleToken.Provider, NonFungibleToken.CollectionPublic}>(nftProviderPath)!
        assert(self.nftProvider.borrow() != nil, message: "Missing or mis-typed TopShot.Collection provider")

        if acct.borrow<&NFTStorefront.Storefront>(from: NFTStorefront.StorefrontStoragePath) == nil {
            let storefront <- NFTStorefront.createStorefront() as! @NFTStorefront.Storefront
            acct.save(<-storefront, to: NFTStorefront.StorefrontStoragePath)
            acct.link<&NFTStorefront.Storefront{NFTStorefront.StorefrontPublic}>(NFTStorefront.StorefrontPublicPath, target: NFTStorefront.StorefrontStoragePath)
        }
        self.storefront = acct.borrow<&NFTStorefront.Storefront>(from: NFTStorefront.StorefrontStoragePath)
            ?? panic("Missing or mis-typed NFTStorefront Storefront")
    }

    execute {
        let topshotFeeAddress = RaribleFee.feeAddress() // TODO Replace with TopShot fee address
        let topshotFeeRate = 0.05

        RaribleOrder.addOrder(
            storefront: self.storefront,
            nftProvider: self.nftProvider,
            nftType: Type<@TopShot.NFT>(),
            nftId: tokenId,
            vaultPath: /public/flowTokenReceiver,
            vaultType: Type<@FlowToken.Vault>(),
            price: price,
            extraCuts: [RaribleOrder.PaymentPart(address: topshotFeeAddress, rate: topshotFeeRate)],
            royalties: []
        )
    }
}

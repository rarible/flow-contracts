import RaribleNFT from "../../../contracts/RaribleNFT.cdc" //template
import FlowToken from "../../../contracts/core/FlowToken.cdc" //template
import FungibleToken from "../../../contracts/core/FungibleToken.cdc"
import NonFungibleToken from "../../../contracts/core/NonFungibleToken.cdc"
import NFTStorefront from "../../../contracts/core/NFTStorefront.cdc"

transaction(
    tokenId: UInt64,
    price: UFix64, 
    originFees: {Addres: UFix64},
    royalties: {Addres: UFix64}, 
    payments: {Addres: UFix64}
) {
        let storefront: &NFTStorefront.Storefront
        let nftProvider: Capability<&{NonFungibleToken.Provider,NonFungibleToken.CollectionPublic}>
        
        prepare(seller: AuthAccount) {
        
            let nftProviderPath = /private/RaribleNFTProviderForNFTStorefront // template
            if !seller.getCapability<&{NonFungibleToken.Provider,NonFungibleToken.CollectionPublic}>(nftProviderPath)!.check() {
                seller.link<&{NonFungibleToken.Provider,NonFungibleToken.CollectionPublic}>(nftProviderPath, target: RaribleNFT.collectionStoragePath /*template*/)
            }

            self.nftProvider = seller.getCapability<&{NonFungibleToken.Provider,NonFungibleToken.CollectionPublic}>(nftProviderPath)!
            assert(self.nftProvider.borrow() != nil, message: "Missing or mis-typed nft collection provider")

            if seller.borrow<&NFTStorefront.Storefront>(from: NFTStorefront.StorefrontStoragePath) == nil {
                let storefront <- NFTStorefront.createStorefront() as! @NFTStorefront.Storefront
                seller.save(<-storefront, to: NFTStorefront.StorefrontStoragePath)
                seller.link<&NFTStorefront.Storefront{NFTStorefront.StorefrontPublic}>(NFTStorefront.StorefrontPublicPath, target: NFTStorefront.StorefrontStoragePath)
            }

            self.storefront = seller.borrow<&NFTStorefront.Storefront>(from: NFTStorefront.StorefrontStoragePath)
                ?? panic("Missing or mis-typed NFTStorefront Storefront")
        }

        execute {
            let saleCuts: [NFTStorefront.SaleCut] = []
            let owner = self.storefront.owner!.address
            let sellerFee = price * RaribleFee.sellerFee
            let vaultPath = /public/flowTokenReceiver //template
            var netto = price
            let receiver = getAccount(RaribleFee.feeAddress()).getCapability<&{FungibleToken.Receiver}>(vaultPath)
            assert(receiver.borrow() != nil, message: "Missing or mis-typed fungible token receiver")

            saleCuts.append(NFTStorefront.SaleCut(receiver: receiver, amount: sellerFee))

            netto = netto - sellerFee

            for k in originFees.keys {
                let amount = price * originFees[k]!
                let receiver = getAccount(k).getCapability<&{FungibleToken.Receiver}>(vaultPath)
                assert(receiver.borrow() != nil, message: "Missing or mis-typed fungible token receiver for originFee")
                saleCuts.append(NFTStorefront.SaleCut(receiver: receiver, amount: amount))
                netto = netto - amount
            }

            for k in royalties.keys {
                let amount = price * royalties[k]!
                let receiver = getAccount(k).getCapability<&{FungibleToken.Receiver}>(vaultPath)
                assert(receiver.borrow() != nil, message: "Missing or mis-typed fungible token receiver for royalty")
                saleCuts.append(NFTStorefront.SaleCut(receiver: receiver, amount: amount))
                netto = netto - amount
            }

            for k in payments.keys {
                let amount = netto * payments[k]!
                let receiver = getAccount(k).getCapability<&{FungibleToken.Receiver}>(vaultPath)
                assert(receiver.borrow() != nil, message: "Missing or mis-typed fungible token receiver for payment")
                saleCuts.append(NFTStorefront.SaleCut(receiver: receiver, amount: amount))
            }

            self.storefront.createListing(
                nftProviderCapability: nftProvider,
                nftType: Type<@RaribleNFT.NFT>(), //template
                nftID: tokenId,
                salePaymentVaultType: Type<@FlowToken.Vault>(), //template
                saleCuts: saleCuts
            )

        }
}

import FungibleToken from "../../../../../flow-contracts/cadence/contracts/core/FungibleToken.cdc"
import NonFungibleToken from "../../../../../flow-contracts/cadence/contracts/core/NonFungibleToken.cdc"
import RaribleOpenBid from "../../../../../flow-contracts/cadence/contracts/RaribleOpenBid.cdc"
import FUSD from "../../../../../flow-contracts/cadence/contracts/core/FUSD.cdc"
import RaribleNFT from "../../../../../flow-contracts/cadence/contracts/RaribleNFT.cdc"

transaction(nftId: UInt64, amount: UFix64, parts: {Address:UFix64}) {
    let openBid: &RaribleOpenBid.OpenBid
    let vault: @FungibleToken.Vault
    let nftReceiver: Capability<&{NonFungibleToken.CollectionPublic}>
    let vaultRef: Capability<&{FungibleToken.Provider,FungibleToken.Balance,FungibleToken.Receiver}>

    prepare(account: AuthAccount) {
        let vaultRefPrivatePath = /private/FlowTokenVaultRefForRaribleOpenBid

        if account.borrow<&RaribleNFT.Collection>(from: RaribleNFT.collectionStoragePath) == nil {
            let collection <- RaribleNFT.createEmptyCollection() as! @RaribleNFT.Collection
            account.save(<-collection, to: RaribleNFT.collectionStoragePath)
            account.link<&{NonFungibleToken.CollectionPublic,NonFungibleToken.Receiver}>(RaribleNFT.collectionPublicPath, target: RaribleNFT.collectionStoragePath)
        }

        self.nftReceiver = account.getCapability<&{NonFungibleToken.CollectionPublic,NonFungibleToken.Receiver}>(RaribleNFT.collectionPublicPath)
        assert(self.nftReceiver.check(), message: "Missing or mis-typed RaribleNFT receiver")

        if !account.getCapability<&{FungibleToken.Provider,FungibleToken.Balance,FungibleToken.Receiver}>(/private/FUSD_vaultRef)!.check() {
            account.link<&{FungibleToken.Provider,FungibleToken.Balance,FungibleToken.Receiver}>(/private/FUSD_vaultRef, target: /storage/fusdVault)
        }

        self.vaultRef = account.getCapability<&{FungibleToken.Provider,FungibleToken.Balance,FungibleToken.Receiver}>(/private/FUSD_vaultRef)!
        assert(self.vaultRef.check(), message: "Missing or mis-typed fungible token vault ref")

        self.openBid = account.borrow<&RaribleOpenBid.OpenBid>(from: RaribleOpenBid.OpenBidStoragePath)
            ?? panic("Missing or mis-typed RaribleOpenBid OpenBid")

        self.vault <- self.vaultRef.borrow()!.withdraw(amount: amount)
    }

    execute {
        let cuts: [RaribleOpenBid.Cut] = []
        for address in parts.keys {
            cuts.append(
                RaribleOpenBid.Cut(
                    receiver: getAccount(address).getCapability<&{FungibleToken.Receiver}>(/public/fusdReceiver),
                    amount: parts[address]!,
                )
            )
        }

        self.openBid.createBid(
            vaultRefCapability: self.vaultRef,
            testVault: <- self.vault,
            rewardCapability: self.nftReceiver,
            nftType: Type<@RaribleNFT.NFT>(),
            nftId: nftId,
            cuts: cuts,
        )
    }
}

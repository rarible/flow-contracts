import FungibleToken from "../../../../../flow-contracts/cadence/contracts/core/FungibleToken.cdc"
import NonFungibleToken from "../../../../../flow-contracts/cadence/contracts/core/NonFungibleToken.cdc"
import RaribleOpenBid from "../../../../../flow-contracts/cadence/contracts/RaribleOpenBid.cdc"
import FlowToken from "../../../../../flow-contracts/cadence/contracts/core/FlowToken.cdc"
import TopShot from "../../../../../flow-contracts/cadence/contracts/third-party/TopShot.cdc"

transaction(nftId: UInt64, amount: UFix64, parts: {Address:UFix64}) {
    let openBid: &RaribleOpenBid.OpenBid
    let vault: @FungibleToken.Vault
    let nftReceiver: Capability<&{NonFungibleToken.CollectionPublic}>
    let vaultRef: Capability<&{FungibleToken.Provider,FungibleToken.Balance,FungibleToken.Receiver}>

    prepare(account: AuthAccount) {
        let vaultRefPrivatePath = /private/FlowTokenVaultRefForRaribleOpenBid

        if account.borrow<&TopShot.Collection>(from: /storage/MomentCollection) == nil {
            let collection <- TopShot.createEmptyCollection() as! @TopShot.Collection
            account.save(<-collection, to: /storage/MomentCollection)
            account.link<&{TopShot.MomentCollectionPublic}>(/public/MomentCollection, target: /storage/MomentCollection)
        }

        self.nftReceiver = account.getCapability<&{TopShot.MomentCollectionPublic}>(/public/MomentCollection)
        assert(self.nftReceiver.check(), message: "Missing or mis-typed TopShot receiver")

        if !account.getCapability<&{FungibleToken.Provider,FungibleToken.Balance,FungibleToken.Receiver}>(/private/FlowToken_vaultRef)!.check() {
            account.link<&{FungibleToken.Provider,FungibleToken.Balance,FungibleToken.Receiver}>(/private/FlowToken_vaultRef, target: /storage/flowTokenVault)
        }

        self.vaultRef = account.getCapability<&{FungibleToken.Provider,FungibleToken.Balance,FungibleToken.Receiver}>(/private/FlowToken_vaultRef)!
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
                    receiver: getAccount(address).getCapability<&{FungibleToken.Receiver}>(/public/flowTokenReceiver),
                    amount: parts[address]!,
                )
            )
        }

        self.openBid.createBid(
            vaultRefCapability: self.vaultRef,
            testVault: <- self.vault,
            rewardCapability: self.nftReceiver,
            nftType: Type<@TopShot.NFT>(),
            nftId: nftId,
            cuts: cuts,
        )
    }
}

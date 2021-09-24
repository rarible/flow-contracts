/*
Status		✅ SEALED
ID		3876c4ef938feb905ee531a3097f32794ceacb99b8210e4a93e14d921eefa0c4
Payer		55ad22f01ef568a1
Authorizers	[f16b42dcb3cf14ce]

Proposal Key:	
    Address	f16b42dcb3cf14ce
    Index	1
    Sequence	48

Payload Signature 0: f16b42dcb3cf14ce
Envelope Signature 0: 55ad22f01ef568a1
Signatures (minimized, use --include signatures)

Events:		 
    Index	0
    Type	A.1654653399040a61.FlowToken.TokensWithdrawn
    Tx ID	3876c4ef938feb905ee531a3097f32794ceacb99b8210e4a93e14d921eefa0c4
    Values
		- amount (UFix64): 3.20000000 
		- from (Address?): 0xf16b42dcb3cf14ce 

    Index	1
    Type	A.1654653399040a61.FlowToken.TokensWithdrawn
    Tx ID	3876c4ef938feb905ee531a3097f32794ceacb99b8210e4a93e14d921eefa0c4
    Values
		- amount (UFix64): 0.08000000 
		- from (Never?): nil 

    Index	2
    Type	A.1654653399040a61.FlowToken.TokensDeposited
    Tx ID	3876c4ef938feb905ee531a3097f32794ceacb99b8210e4a93e14d921eefa0c4
    Values
		- amount (UFix64): 0.08000000 
		- to (Address?): 0x3896d4b8f0636f6d 

    Index	3
    Type	A.1654653399040a61.FlowToken.TokensWithdrawn
    Tx ID	3876c4ef938feb905ee531a3097f32794ceacb99b8210e4a93e14d921eefa0c4
    Values
		- amount (UFix64): 0.32000000 
		- from (Never?): nil 

    Index	4
    Type	A.1654653399040a61.FlowToken.TokensDeposited
    Tx ID	3876c4ef938feb905ee531a3097f32794ceacb99b8210e4a93e14d921eefa0c4
    Values
		- amount (UFix64): 0.32000000 
		- to (Address?): 0x77b78d7d3f0d1787 

    Index	5
    Type	A.1654653399040a61.FlowToken.TokensDeposited
    Tx ID	3876c4ef938feb905ee531a3097f32794ceacb99b8210e4a93e14d921eefa0c4
    Values
		- amount (UFix64): 2.80000000 
		- to (Address?): 0x2a856d01f32af872 

    Index	6
    Type	A.c2d564119d2e5c3d.VIV3.TokenPurchased
    Tx ID	3876c4ef938feb905ee531a3097f32794ceacb99b8210e4a93e14d921eefa0c4
    Values
		- id (UInt64): 5348 
		- price (UFix64): 3.20000000 
		- seller (Address?): 0x2a856d01f32af872 

    Index	7
    Type	A.f4264ac8f3256818.Evolution.Withdraw
    Tx ID	3876c4ef938feb905ee531a3097f32794ceacb99b8210e4a93e14d921eefa0c4
    Values
		- id (UInt64): 5348 
		- from (Address?): 0x2a856d01f32af872 

    Index	8
    Type	A.f4264ac8f3256818.Evolution.Deposit
    Tx ID	3876c4ef938feb905ee531a3097f32794ceacb99b8210e4a93e14d921eefa0c4
    Values
		- id (UInt64): 5348 
		- to (Address?): 0xf16b42dcb3cf14ce 

 */

import FungibleToken from "../contracts/FungibleToken.cdc"
import NonFungibleToken from "../contracts/NonFungibleToken.cdc"
import FlowToken from "../contracts/FlowToken.cdc"
import VIV3 from "../contracts/VIV3.cdc"
import Evolution from "../contracts/Evolution.cdc"

transaction {
    let vault: @FlowToken.Vault

    prepare(acct: AuthAccount) {
        // Create a collection to store the purchase if none present
        if acct.borrow<&Evolution.Collection>(from: /storage/f4264ac8f3256818_Evolution_Collection) == nil {
            let collection <- Evolution.createEmptyCollection() as! @Evolution.Collection

            acct.save(<-collection, to: /storage/f4264ac8f3256818_Evolution_Collection)

            acct.link<&{Evolution.EvolutionCollectionPublic}>(/public/f4264ac8f3256818_Evolution_Collection, target: /storage/f4264ac8f3256818_Evolution_Collection)
        }

        let provider = acct.borrow<&FlowToken.Vault{FungibleToken.Provider}>(from: /storage/flowTokenVault)!
        self.vault <- provider.withdraw(amount: UFix64(3.20)) as! @FlowToken.Vault
    }

    execute {
        let seller = getAccount(0x2a856d01f32af872)
        let buyer = getAccount(0xf16b42dcb3cf14ce)

        let buyerRef = buyer.getCapability(/public/f4264ac8f3256818_Evolution_Collection).borrow<&{Evolution.EvolutionCollectionPublic}>()
                    ?? panic("Could not borrow a reference to the buyer's token collection")

        let tokenSaleCollection = seller.getCapability(/public/f4264ac8f3256818_Evolution_Collection_VIV3xFLOW)
                                    .borrow<&{VIV3.TokenSale}>() ?? panic("Could not borrow from sale in storage")
        let purchasedToken <- tokenSaleCollection.purchase(tokenId: 5348, kind: Type<@Evolution.NFT>(), vault: <-self.vault)
        buyerRef.deposit(token: <-purchasedToken)
    }
}

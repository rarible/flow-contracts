/*
Status		✅ SEALED
ID		8e4aa111602c159f78f281bd2f22a03dc80b612701cc1f5f1d97c1451aba8bb3
Payer		d7db5ffc2d1c119b
Authorizers	[f4264ac8f3256818 cddfecaddebc9631]

Proposal Key:	
    Address	f4264ac8f3256818
    Index	20
    Sequence	20

Payload Signature 0: f4264ac8f3256818
Payload Signature 1: cddfecaddebc9631
Envelope Signature 0: d7db5ffc2d1c119b
Signatures (minimized, use --include signatures)

Events:		 
    Index	0
    Type	A.f4264ac8f3256818.Evolution.Withdraw
    Tx ID	8e4aa111602c159f78f281bd2f22a03dc80b612701cc1f5f1d97c1451aba8bb3
    Values
		- id (UInt64): 6445 
		- from (Address?): 0xf4264ac8f3256818 

    Index	1
    Type	A.f4264ac8f3256818.Evolution.Withdraw
    Tx ID	8e4aa111602c159f78f281bd2f22a03dc80b612701cc1f5f1d97c1451aba8bb3
    Values
		- id (UInt64): 3946 
		- from (Address?): 0xf4264ac8f3256818 

    Index	2
    Type	A.f4264ac8f3256818.Evolution.Withdraw
    Tx ID	8e4aa111602c159f78f281bd2f22a03dc80b612701cc1f5f1d97c1451aba8bb3
    Values
		- id (UInt64): 6445 
		- from (Never?): nil 

    Index	3
    Type	A.f4264ac8f3256818.Evolution.Deposit
    Tx ID	8e4aa111602c159f78f281bd2f22a03dc80b612701cc1f5f1d97c1451aba8bb3
    Values
		- id (UInt64): 6445 
		- to (Address?): 0xcddfecaddebc9631 

    Index	4
    Type	A.f4264ac8f3256818.Evolution.Withdraw
    Tx ID	8e4aa111602c159f78f281bd2f22a03dc80b612701cc1f5f1d97c1451aba8bb3
    Values
		- id (UInt64): 3946 
		- from (Never?): nil 

    Index	5
    Type	A.f4264ac8f3256818.Evolution.Deposit
    Tx ID	8e4aa111602c159f78f281bd2f22a03dc80b612701cc1f5f1d97c1451aba8bb3
    Values
		- id (UInt64): 3946 
		- to (Address?): 0xcddfecaddebc9631 

 */

import FungibleToken from "../contracts/FungibleToken.cdc"
import Evolution from "../contracts/Evolution.cdc"

// This transaction is used to send the Collectibles in a "pack" to
// a user's collection

transaction {

    prepare(acct: AuthAccount, recipient: AuthAccount) {

        // setup recipient account to receive collectible
        if recipient.borrow<&Evolution.Collection>(from: /storage/f4264ac8f3256818_Evolution_Collection) == nil {
            let collection <- Evolution.createEmptyCollection() as! @Evolution.Collection
            recipient.save(<-collection, to: /storage/f4264ac8f3256818_Evolution_Collection)
            recipient.link<&{Evolution.EvolutionCollectionPublic}>(/public/f4264ac8f3256818_Evolution_Collection, target: /storage/f4264ac8f3256818_Evolution_Collection)
        }

        // borrow a reference to the recipient's collectibles collection
        let receiverRef = recipient.getCapability(/public/f4264ac8f3256818_Evolution_Collection)
            .borrow<&{Evolution.EvolutionCollectionPublic}>()
            ?? panic("Could not borrow reference to receiver's collection")

        let itemIds: [UInt64] = [UInt64(6445),UInt64(3946)]
        // borrow a reference to the owner's collectibles collection
        let collection <- acct.borrow<&Evolution.Collection>
            (from: /storage/f4264ac8f3256818_Evolution_Collection)!
            .batchWithdraw(ids: itemIds)

        // Deposit the pack of collectibles to the recipient's collection
        receiverRef.batchDeposit(tokens: <-collection)
    }
}

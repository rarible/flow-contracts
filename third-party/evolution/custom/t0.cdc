/*
Status		✅ SEALED
ID		cf2bc2e243c1569e93ddd8b9e69a2d61b965b9900ec34cbfbdda4306f0a51c1d
Payer		d7db5ffc2d1c119b
Authorizers	[ab4b34c6f1aacbc3]

Proposal Key:	
    Address	ab4b34c6f1aacbc3
    Index	0
    Sequence	7

Payload Signature 0: ab4b34c6f1aacbc3
Envelope Signature 0: d7db5ffc2d1c119b
Signatures (minimized, use --include signatures)

Events:		 
    Index	0
    Type	A.f4264ac8f3256818.Evolution.Withdraw
    Tx ID	cf2bc2e243c1569e93ddd8b9e69a2d61b965b9900ec34cbfbdda4306f0a51c1d
    Values
		- id (UInt64): 509 
		- from (Address?): 0xab4b34c6f1aacbc3 

    Index	1
    Type	A.f4264ac8f3256818.Evolution.Withdraw
    Tx ID	cf2bc2e243c1569e93ddd8b9e69a2d61b965b9900ec34cbfbdda4306f0a51c1d
    Values
		- id (UInt64): 5445 
		- from (Address?): 0xab4b34c6f1aacbc3 

    Index	2
    Type	A.f4264ac8f3256818.Evolution.Withdraw
    Tx ID	cf2bc2e243c1569e93ddd8b9e69a2d61b965b9900ec34cbfbdda4306f0a51c1d
    Values
		- id (UInt64): 509 
		- from (Never?): nil 

    Index	3
    Type	A.f4264ac8f3256818.Evolution.Deposit
    Tx ID	cf2bc2e243c1569e93ddd8b9e69a2d61b965b9900ec34cbfbdda4306f0a51c1d
    Values
		- id (UInt64): 509 
		- to (Address?): 0xafc08315ebddb70 

    Index	4
    Type	A.f4264ac8f3256818.Evolution.Withdraw
    Tx ID	cf2bc2e243c1569e93ddd8b9e69a2d61b965b9900ec34cbfbdda4306f0a51c1d
    Values
		- id (UInt64): 5445 
		- from (Never?): nil 

    Index	5
    Type	A.f4264ac8f3256818.Evolution.Deposit
    Tx ID	cf2bc2e243c1569e93ddd8b9e69a2d61b965b9900ec34cbfbdda4306f0a51c1d
    Values
		- id (UInt64): 5445 
		- to (Address?): 0xafc08315ebddb70 

 */
// batch transfer
import Evolution from "../contracts/Evolution.cdc"

// This transaction is used to send the Evolution Collectibles in a
// a user's collection to another address

transaction(address: Address) {

    prepare(acct: AuthAccount) {

        let recipient = getAccount(address/*0x0afc08315ebddb70*/)

        // borrow a reference to the recipient's collectibles collection
        let receiverRef = recipient.getCapability(/public/f4264ac8f3256818_Evolution_Collection)
            .borrow<&{Evolution.EvolutionCollectionPublic}>()
            ?? panic("Could not borrow reference to receiver's collection")

        let collectionRef = acct.getCapability(/public/f4264ac8f3256818_Evolution_Collection)
                                .borrow<&{Evolution.EvolutionCollectionPublic}>()!

        let collectibleIds = collectionRef.getIDs()

        // borrow a reference to the owner's collectibles collection
        let collection <- acct.borrow<&Evolution.Collection>
            (from: /storage/f4264ac8f3256818_Evolution_Collection)!
            .batchWithdraw(ids: collectibleIds)

        // Deposit the collectibles to the recipient's collection
        receiverRef.batchDeposit(tokens: <-collection)
    }
}

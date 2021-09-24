/*
Status		✅ SEALED
ID		2b1b6480600d2115cf17566994a20c0e33a7c0f3ff76dff5e9d06631b4bd7b65
Payer		d7db5ffc2d1c119b
Authorizers	[e821652987ce9a2e]

Proposal Key:	
    Address	e821652987ce9a2e
    Index	0
    Sequence	13

Payload Signature 0: e821652987ce9a2e
Envelope Signature 0: d7db5ffc2d1c119b
Signatures (minimized, use --include signatures)

Events:		 
    Index	0
    Type	A.f4264ac8f3256818.Evolution.Withdraw
    Tx ID	2b1b6480600d2115cf17566994a20c0e33a7c0f3ff76dff5e9d06631b4bd7b65
    Values
		- id (UInt64): 5162 
		- from (Address?): 0xe821652987ce9a2e 

    Index	1
    Type	A.f4264ac8f3256818.Evolution.Withdraw
    Tx ID	2b1b6480600d2115cf17566994a20c0e33a7c0f3ff76dff5e9d06631b4bd7b65
    Values
		- id (UInt64): 5162 
		- from (Never?): nil 

    Index	2
    Type	A.f4264ac8f3256818.Evolution.Deposit
    Tx ID	2b1b6480600d2115cf17566994a20c0e33a7c0f3ff76dff5e9d06631b4bd7b65
    Values
		- id (UInt64): 5162 
		- to (Address?): 0x26d795677db2d68c 

 */
// transfer
import Evolution from "../contracts/Evolution.cdc"

// This transaction is used to send the Evolution Collectibles in a
// a user's collection to another address

transaction {

    prepare(acct: AuthAccount) {

        let recipient = getAccount(0x26d795677db2d68c)

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

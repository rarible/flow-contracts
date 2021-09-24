/*
Status		✅ SEALED
ID		a586a53b8fd17fcaf13a36236f2a70c96cbb82b0737be8745cfd9985f64c0b2f
Payer		d7db5ffc2d1c119b
Authorizers	[f4264ac8f3256818]

Proposal Key:	
    Address	f4264ac8f3256818
    Index	0
    Sequence	263

Payload Signature 0: f4264ac8f3256818
Envelope Signature 0: d7db5ffc2d1c119b
Signatures (minimized, use --include signatures)

Events:		 
    Index	0
    Type	A.f4264ac8f3256818.Evolution.ItemAddedToSet
    Tx ID	a586a53b8fd17fcaf13a36236f2a70c96cbb82b0737be8745cfd9985f64c0b2f
    Values
		- setId (UInt32): 1 
		- itemId (UInt32): 22 



Arguments	No arguments

 */

import Evolution from "../contracts/Evolution.cdc"

// This transaction adds multiple Items to a set

transaction() {

    let adminRef: &Evolution.Admin

    prepare(acct: AuthAccount) {

        // borrow a reference to the Admin resource in storage
        self.adminRef = acct.borrow<&Evolution.Admin>(from: /storage/EvolutionAdmin)!
    }

    execute {

        // borrow a reference to the set to be added to
        let setRef = self.adminRef.borrowSet(setId: 1)

        // Add the specified Items Ids
        let itemIds: [UInt32] = [UInt32(22)]
        setRef.addItems(itemIds: itemIds)
    }
}

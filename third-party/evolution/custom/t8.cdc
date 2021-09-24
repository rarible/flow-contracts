/*
Status		✅ SEALED
ID		c6f98fb24f6203b22657e7d58e9262c4e71e419f0c9f064f4b9d4257dbe15e51
Payer		d7db5ffc2d1c119b
Authorizers	[f4264ac8f3256818]

Proposal Key:	
    Address	f4264ac8f3256818
    Index	0
    Sequence	262

Payload Signature 0: f4264ac8f3256818
Envelope Signature 0: d7db5ffc2d1c119b
Signatures (minimized, use --include signatures)

Events:		 
    Index	0
    Type	A.f4264ac8f3256818.Evolution.ItemCreated
    Tx ID	c6f98fb24f6203b22657e7d58e9262c4e71e419f0c9f064f4b9d4257dbe15e51
    Values
		- id (UInt32): 22 
		- metadata (): {"Title": "Cerulean Hunters", "Description": "Tiburo hunting rite of passage", "Hash": "46e3dbf670d3ce23d497e7fb946137dde0c0dcbc40f084505b276c1a35643130"}
		hex: 7b225469746c65223a2022436572756c65616e2048756e74657273222c20224465736372697074696f6e223a202254696275726f2068756e74696e672072697465206f662070617373616765222c202248617368223a202234366533646266363730643363653233643439376537666239343631333764646530633064636263343066303834353035623237366331613335363433313330227d 



Arguments	No arguments

 */

import Evolution from "../contracts/Evolution.cdc"

// This transaction creates a new item struct
// and stores it in the Evolution smart contract

transaction() {
    prepare(acct: AuthAccount) {

        // borrow a reference to the admin resource
        let admin = acct.borrow<&Evolution.Admin>(from: /storage/EvolutionAdmin)
            ?? panic("No admin resource in storage")
        admin.createItem(metadata: {"Title":"Cerulean Hunters","Description": "Tiburo hunting rite of passage","Hash":"46e3dbf670d3ce23d497e7fb946137dde0c0dcbc40f084505b276c1a35643130"})
    }
}

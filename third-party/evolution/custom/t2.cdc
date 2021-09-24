/*
Status		✅ SEALED
ID		83b848f8c98c0fe2318c32612071fb11dcce9b05588c424812016103536191da
Payer		55ad22f01ef568a1
Authorizers	[26d795677db2d68c]

Proposal Key:	
    Address	26d795677db2d68c
    Index	0
    Sequence	4

Payload Signature 0: 26d795677db2d68c
Payload Signature 1: 26d795677db2d68c
Envelope Signature 0: 55ad22f01ef568a1
Signatures (minimized, use --include signatures)

Events:		 
    Index	0
    Type	A.f4264ac8f3256818.Evolution.Withdraw
    Tx ID	83b848f8c98c0fe2318c32612071fb11dcce9b05588c424812016103536191da
    Values
		- id (UInt64): 5162 
		- from (Address?): 0x26d795677db2d68c 

    Index	1
    Type	A.f4264ac8f3256818.Evolution.Deposit
    Tx ID	83b848f8c98c0fe2318c32612071fb11dcce9b05588c424812016103536191da
    Values
		- id (UInt64): 5162 
		- to (Address?): 0x64df6f7d95bdb7f 



Arguments (2):
    - Argument 0: {"type":"UInt64","value":"5162"}

    - Argument 1: {"type":"Address","value":"0x064df6f7d95bdb7f"}

 */

import NonFungibleToken from "../contracts/NonFungibleToken.cdc"
import Evolution from "../contracts/Evolution.cdc"

transaction(id: UInt64, to: Address) {
  let sentNFT: @NonFungibleToken.NFT

  prepare(signer: AuthAccount) {
    let collectionRef = signer.borrow<&NonFungibleToken.Collection>(from: /storage/f4264ac8f3256818_Evolution_Collection)
      ?? panic("Could not borrow reference collection")

    self.sentNFT <- collectionRef.withdraw(withdrawID: id)
  }

  execute {
    let recipient = getAccount(to)

    let receiverRef = recipient.getCapability(/public/f4264ac8f3256818_Evolution_Collection).borrow<&{Evolution.EvolutionCollectionPublic}>()
      ?? panic("Could not borrow receiver reference to the recipient's Vault")

    receiverRef.deposit(token: <-self.sentNFT)
  }
}

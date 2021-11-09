import Evolution from "../../../contracts/third-party/Evolution.cdc"

// Burn Evolution on signer account by tokenId
//
transaction(tokenId: UInt64) {
    prepare(account: AuthAccount) {
        let collection = account.borrow<&Evolution.Collection>(from: /storage/f4264ac8f3256818_Evolution_Collection)!
        destroy collection.withdraw(withdrawID: tokenId)
    }
}
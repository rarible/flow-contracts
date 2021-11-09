import TopShot from "../../../contracts/third-party/TopShot.cdc"

// Burn TopShot on signer account by tokenId
//
transaction(tokenId: UInt64) {
    prepare(account: AuthAccount) {
        let collection = account.borrow<&TopShot.Collection>(from: /storage/MomentCollection)!
        destroy collection.withdraw(withdrawID: tokenId)
    }
}
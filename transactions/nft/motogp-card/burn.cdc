import MotoGPCard from "../../../contracts/third-party/MotoGPCard.cdc"

// Burn MotoGPCard on signer account by tokenId
//
transaction(tokenId: UInt64) {
    prepare(account: AuthAccount) {
        let collection = account.borrow<&MotoGPCard.Collection>(from: /storage/motogpCardCollection)!
        destroy collection.withdraw(withdrawID: tokenId)
    }
}
import NonFungibleToken from "../../contracts/core/NonFungibleToken.cdc"
import RaribleNFT from "../../contracts/RaribleNFT.cdc"

// Burn RaribleNFT on signer account by tokenId
//
transaction(tokenId: UInt64) {
    prepare(account: AuthAccount) {
        let collection = account.borrow<&RaribleNFT.Collection>(from: RaribleNFT.collectionStoragePath)!
        destroy collection.withdraw(withdrawID: tokenId)
    }
}

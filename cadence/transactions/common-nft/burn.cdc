import NonFungibleToken from "../../contracts/core/NonFungibleToken.cdc"
import CommonNFT from "../../contracts/CommonNFT.cdc"

// Burn CommonNFT on signer account by tokenId
//
transaction(tokenId: UInt64) {
    prepare(account: AuthAccount) {
        let collection = account.borrow<&CommonNFT.Collection>(from: CommonNFT.collectionStoragePath)!
        destroy collection.withdraw(withdrawID: tokenId)
    }
}

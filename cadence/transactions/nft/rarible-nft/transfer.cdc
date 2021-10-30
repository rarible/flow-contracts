import NonFungibleToken from "../../../contracts/core/NonFungibleToken.cdc"
import RaribleNFT from "../../../contracts/RaribleNFT.cdc"

// transfer RaribleNFT token with tokenId to given address
//
transaction(tokenId: UInt64, to: Address) {
    let token: @NonFungibleToken.NFT
    let receiver: Capability<&{NonFungibleToken.CollectionPublic,NonFungibleToken.Receiver}>

    prepare(acct: AuthAccount) {
        let collection = acct.borrow<&RaribleNFT.Collection>(from: RaribleNFT.collectionStoragePath)
            ?? panic("Missing NFT collection on signer account")
        self.token <- collection.withdraw(withdrawID: tokenId)
        self.receiver = getAccount(to).getCapability<&{NonFungibleToken.CollectionPublic,NonFungibleToken.Receiver}>(RaribleNFT.collectionPublicPath)
    }

    execute {
        let receiver = self.receiver.borrow()!
        receiver.deposit(token: <- self.token)
    }
}
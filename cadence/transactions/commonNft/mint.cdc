import NonFungibleToken from "../../contracts/core/NonFungibleToken.cdc"
import CommonNFT from "../../contracts/CommonNFT.cdc"

// Mint CommonNFT token to signer acct
//
transaction(metadata: String, royalties: [CommonNFT.Royalty]) {
    let minter: Capability<&CommonNFT.Minter>
    let receiver: Capability<&{NonFungibleToken.Receiver}>

    prepare(acct: AuthAccount) {
        if acct.borrow<&CommonNFT.Collection>(from: CommonNFT.collectionStoragePath) == nil {
            let collection <- CommonNFT.createEmptyCollection() as! @CommonNFT.Collection
            acct.save(<- collection, to: CommonNFT.collectionStoragePath)
            acct.link<&{NonFungibleToken.CollectionPublic,NonFungibleToken.Receiver}>(CommonNFT.collectionPublicPath, target: CommonNFT.collectionStoragePath)
        }

        self.minter = CommonNFT.minter()
        self.receiver = acct.getCapability<&{NonFungibleToken.Receiver}>(CommonNFT.collectionPublicPath)
    }

    execute {
        let minter = self.minter.borrow() ?? panic("Could not borrow receiver capability (maybe receiver not configured?)")
        minter.mintTo(creator: self.receiver, metadata: metadata, royalties: royalties)
    }
}

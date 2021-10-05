import NonFungibleToken from "../../contracts/NonFungibleToken.cdc"
import CommonNFT from "../../contracts/CommonNFT.cdc"

transaction(metadata: String, royalties: [CommonNFT.Royalties]) {
    let minter: Capability<&CommonNFT.Minter>
    let receiver: Capability<&{NonFungibleToken.Receiver}>

    prepare(account: AuthAccount) {
        if account.borrow<&CommonNFT.Collection>(from: CommonNFT.collectionStoragePath) == nil {
            let collection <- CommonNFT.createEmptyCollection() as! @CommonNFT.Collection
            account.save(<- collection, to: CommonNFT.collectionStoragePath)
            account.link<&{NonFungibleToken.CollectionPublic,NonFungibleToken.Receiver}>(CommonNFT.collectionPublicPath, target: CommonNFT.collectionStoragePath)
        }

        self.minter = CommonNFT.minter()
        self.receiver = CommonNFT.receiver(account.address)
    }

    execute {
        let minter = self.minter.borrow() ?? panic("Could not borrow receiver capability (maybe receiver not configured?)")
        minter.mintTo(creator: self.receiver, metadata: metadata, royalties: royalties)
    }
}

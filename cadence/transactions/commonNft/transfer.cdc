import NonFungibleToken from "../../contracts/NonFungibleToken.cdc"
import CommonNFT from "../../contracts/CommonNFT.cdc"

transaction(tokenId: UInt64, to: Address) {
    let token: @NonFungibleToken.NFT
    let receiver: Capability<&{NonFungibleToken.Receiver}>

    prepare(account: AuthAccount) {
        if account.borrow<&CommonNFT.Collection>(from: CommonNFT.collectionStoragePath) == nil {
            let collection <- CommonNFT.createEmptyCollection() as! @CommonNFT.Collection
            account.save(<- collection, to: CommonNFT.collectionStoragePath)
            account.link<&{NonFungibleToken.CollectionPublic,NonFungibleToken.Receiver}>(CommonNFT.collectionPublicPath, target: CommonNFT.collectionStoragePath)
        }

        let collection = account.borrow<&CommonNFT.Collection>(from: CommonNFT.collectionStoragePath)!
        self.token <- collection.withdraw(withdrawID: tokenId)
        self.receiver = CommonNFT.receiver(to)
    }

    execute {
        let receiver = self.receiver.borrow()!
        receiver.deposit(token: <- self.token)
    }
}

import NonFungibleToken from 0xNONFUNGIBLETOKEN
import CommonNFT from 0xCOMMONNFT

transaction(metadata: String, royalties: [CommonNFT.Royalties]) {
    let minter: Capability<&CommonNFT.Minter>
    let receiver: Capability<&{NonFungibleToken.Receiver}>

    prepare(account: AuthAccount) {
        self.minter = CommonNFT.minter()
        CommonNFT.collectionRef(account)
        self.receiver = CommonNFT.receiver(address: account.address)
    }

    execute {
        let minter = self.minter.borrow() ?? panic("Could not borrow receiver capability (maybe receiver not configured?)")
        minter.mintTo(creator: self.receiver, metadata: metadata, royalties: royalties)
    }
}

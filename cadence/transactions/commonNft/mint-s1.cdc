import NonFungibleToken from 0xNONFUNGIBLETOKEN
import CommonNFTDraft from 0xCOMMONNFTDRAFT
import NFTPlus from 0xNFTPLUS

transaction(creator: Address, royalties: [NFTPlus.Royalties]) {
    let minter: &CommonNFTDraft.Minter
    let receiver: Capability<&{NonFungibleToken.Receiver}>

    prepare(account: AuthAccount) {
        self.minter = CommonNFTDraft.minter().borrow() ?? panic("Could not borrow receiver capability (maybe receiver not configured?)")
        self.receiver = CommonNFTDraft.receiver(creator)
    }

    execute {
        self.minter.mint(creator: self.receiver, royalties: royalties)
    }
}

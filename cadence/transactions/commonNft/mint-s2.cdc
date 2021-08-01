import NonFungibleToken from 0xNONFUNGIBLETOKEN
import CommonNFTDraft from 0xCOMMONNFTDRAFT
import CommonNFT from 0xCOMMONNFT
import NFTPlus from 0xNFTPLUS

transaction(address: Address, tokenId: UInt64, metadata: String) {
    let minter: &CommonNFT.Minter
    let receiver: Capability<&{NonFungibleToken.Receiver}>
    let draft: @CommonNFTDraft.NFT

    prepare(account: AuthAccount) {
        self.minter = CommonNFT.minter().borrow() ?? panic("Could not borrow receiver capability (maybe receiver not configured?)")
        self.receiver = CommonNFT.receiver(address)
        self.draft = CommonNFTDraft.draftProvider(address).borrow()!.take(tokenId: tokenId)
    }

    execute {
        self.minter.mintTo(creator: self.receiver, metadata: metadata, royalties: royalties)
    }
}

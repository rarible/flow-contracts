import NonFungibleToken from 0xNONFUNGIBLETOKEN
import NFTPlus from 0xNFTPLUS
import CommonNFT from 0xCOMMONNFT

transaction(creator: Address, royalties: [NFTPlus.Royalties]) {
    let minter: &CommonNFT.Minter

    prepare(account: AuthAccount) {
        self.minter = CommonNFT.minter().borrow() ?? panic("Could not borrow receiver capability (maybe receiver not configured?)")
    }

    execute {
        self.minter.mintDraft(creator: creator, royalties: royalties)
    }
}

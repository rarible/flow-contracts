import NonFungibleToken from 0xNONFUNGIBLETOKEN
import NFTPlus from 0xNFTPLUS
import CommonNFT from 0xCOMMONNFT

transaction(draftId: UInt64, creator: Address, metadata: String) {
    let minter: &CommonNFT.Minter

    prepare(account: AuthAccount) {
        self.minter = CommonNFT.minter().borrow() ?? panic("Could not borrow receiver capability (maybe receiver not configured?)")
    }

    execute {
        self.minter.mintItem(tokenId: draftId, creator: creator, metadata: metadata)
    }
}

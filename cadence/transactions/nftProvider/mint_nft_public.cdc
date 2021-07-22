/**
 * Mint NFT through public interface of main account
 */
import NonFungibleToken from 0xNONFUNGIBLETOKENADDRESS
import NFTProvider from 0xNFTPROVIDERADDRESS

transaction(royalties: [NFTProvider.Royalties]?, metadata: String) {
    
    let signerAddress: Address
    let receiver: &{NonFungibleToken.CollectionPublic}
    let minter: &{NFTProvider.Minter}

    prepare(signer: AuthAccount) {
        self.signerAddress = signer.address

        self.receiver = signer.getCapability<&{NonFungibleToken.CollectionPublic}>(/public/NFTCollection).borrow()
            ?? panic("Could not borrow receiver reference")

        let provider = getAccount(NFTProvider.minterAddress())
        self.minter = provider.getCapability<&{NFTProvider.Minter}>(/public/Minter).borrow()
            ?? panic("could not borrow minter reference")
    }

    execute {
        let nft <- self.minter.mint(
            creator: self.signerAddress,
            royalties: royalties ?? [],
            metadata: metadata,
        )
        self.receiver.deposit(token: <-nft)
    }
}

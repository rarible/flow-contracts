/**
 * Mint NFT through public interface of main account
 */
import NonFungibleToken from "../../contracts/NonFungibleToken.cdc"
import NFTProvider from "../../contracts/NFTProvider.cdc"

transaction(collection: String, uri: String, title: String, description: String?, data: [UInt8]?, properties: {String:String}?, royalties: [NFTProvider.Royalties]?) {
    
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
        let metadata = NFTProvider.Metadata(
            uri: uri,
            title: title,
            description: description,
            data: data ?? [],
            properties: properties ?? {}
        )
        let nft <- self.minter.mint(
            collection: collection,
            creator: self.signerAddress,
            createDate: getCurrentBlock().timestamp,
            royalties: royalties ?? [],
            metadata: metadata
        )
        self.receiver.deposit(token: <-nft)
    }
}

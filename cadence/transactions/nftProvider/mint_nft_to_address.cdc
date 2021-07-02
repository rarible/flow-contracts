/**
 * Mint NFT from main account to address
 */
import NonFungibleToken from "../../contracts/NonFungibleToken.cdc"
import NFTProvider from "../../contracts/NFTProvider.cdc"

transaction(address: Address, collection: String, uri: String, title: String, description: String?, data: [UInt8]?, properties: {String:String}?, royalties: [NFTProvider.Royalties]?) {

    let receiver: &{NonFungibleToken.CollectionPublic}
    let minter: &{NFTProvider.Minter}
    
    prepare (signer: AuthAccount) {
        self.receiver = getAccount(address).getCapability<&{NonFungibleToken.CollectionPublic}>(/public/NFTCollection).borrow()
            ?? panic("Could not borrow receiver reference")
        self.minter = signer.borrow<&{NFTProvider.Minter}>(from: /storage/NFTMinter)
            ?? panic("Could not borrow minter reference")
    }

    execute {
        let metadata = NFTProvider.Metadata(
            uri: uri,
            title: title,
            description: description ?? "",
            data: data ?? [],
            properties: properties ?? {}
        )
        let nft <- self.minter.mint(
            collection: collection,
            creator: address,
            createDate: getCurrentBlock().timestamp,
            royalties: royalties ?? [],
            metadata: metadata
        )
        self.receiver.deposit(token: <-nft)
    }
}

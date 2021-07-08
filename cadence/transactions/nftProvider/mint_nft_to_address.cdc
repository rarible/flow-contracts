/**
 * Mint NFT from main account to address
 */
import NonFungibleToken from "../../contracts/NonFungibleToken.cdc"
import NFTProvider from "../../contracts/NFTProvider.cdc"

transaction(address: Address, collection: String, royalties: [NFTProvider.Royalties]?, metadata: NFTProvider.Metadata) {

    let receiver: &{NonFungibleToken.CollectionPublic}
    let minter: &{NFTProvider.Minter}
    
    prepare (signer: AuthAccount) {
        self.receiver = getAccount(address).getCapability<&{NonFungibleToken.CollectionPublic}>(/public/NFTCollection).borrow()
            ?? panic("Could not borrow receiver reference")
        self.minter = signer.borrow<&{NFTProvider.Minter}>(from: /storage/NFTMinter)
            ?? panic("Could not borrow minter reference")
    }

    execute {
        let nft <- self.minter.mint(
            collection: collection,
            creator: address,
            royalties: royalties ?? [],
            metadata: metadata
        )
        self.receiver.deposit(token: <-nft)
    }
}

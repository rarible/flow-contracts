/**
 * Initialize storage of signer account as NFT holder
 */
import NonFungibleToken from 0xNONFUNGIBLETOKEN
import NFTProvider from 0xNFTPROVIDER

transaction {
    prepare(signer: AuthAccount) {
        let collection <- NFTProvider.createEmptyCollection()
        signer.save<@NonFungibleToken.Collection>(<-collection, to: /storage/NFTCollection)
        signer.link<&{NonFungibleToken.CollectionPublic}>(/public/NFTCollection, target: /storage/NFTCollection)
    }
}

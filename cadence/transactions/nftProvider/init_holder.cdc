/**
 * Initialize storage of signer account as NFT holder
 */
import NonFungibleToken from "../../contracts/NonFungibleToken.cdc"
import NFTProvider from "../../contracts/NFTProvider.cdc"

transaction {
    prepare(signer: AuthAccount) {
        let collection <- NFTProvider.createEmptyCollection()
        signer.save<@NonFungibleToken.Collection>(<-collection, to: /storage/NFTCollection)
        signer.link<&{NonFungibleToken.CollectionPublic}>(/public/NFTCollection, target: /storage/NFTCollection)
    }
}

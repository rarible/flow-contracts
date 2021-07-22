/**
 * Deinitialize NFT holder account
 * !!! BURNS ALL NFT !!!
 */
transaction {
    prepare (signer: AuthAccount) {
        signer.unlink(/public/NFTCollection)
        let collection <- signer.load<@AnyResource>(from: /storage/NFTCollection)
        destroy collection
        signer.unlink(/public/Minter)
        let minter <- signer.load<@AnyResource>(from: /storage/NFTMinter)
        destroy minter
    }
}

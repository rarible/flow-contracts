/**
 * Deinitialize NFT holder account
 * !!! BURNS ALL NFT !!!
 */
transaction {
    prepare (signer: AuthAccount) {
        signer.unlink(/public/NFTCollection)
        let collection <- signer.load<@AnyResource>(from: /storage/NFTCollection)
        destroy collection
    }
}

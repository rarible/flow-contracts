/**
 * Burn owned NFT by id
 * Signer must be a token holder
 *
 * @param id NFT identifier
 */
import NonFungibleToken from "../../contracts/NonFungibleToken.cdc"
import NFTProvider from "../../contracts/NFTProvider.cdc"

transaction (id: UInt64) {

    let sender: &AnyResource{NonFungibleToken.Provider}

    prepare(signer: AuthAccount) {
        self.sender = signer.borrow<&AnyResource{NonFungibleToken.Provider}>(from: /storage/NFTCollection)
            ?? panic("Could not borrow sender reference")
    }

    execute {
        let nft <- self.sender.withdraw(withdrawID: id)
        destroy nft
    }
}

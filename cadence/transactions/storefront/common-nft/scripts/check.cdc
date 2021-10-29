import NonFungibleToken from "../../../../contracts/core/NonFungibleToken.cdc"
import RaribleNFT from "../../../../contracts/RaribleNFT.cdc"

// check RaribleNFT collection is available on given address
//
pub fun main(address: Address): Bool {
    return getAccount(address)
        .getCapability<&{NonFungibleToken.Receiver}>(RaribleNFT.collectionPublicPath)
        .check()
}

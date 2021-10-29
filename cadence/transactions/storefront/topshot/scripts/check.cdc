import NonFungibleToken from "../../../../contracts/core/NonFungibleToken.cdc"
import TopShot from "../../../../contracts/third-party/TopShot.cdc"

// check RaribleNFT collection is available on given address
//
pub fun main(address: Address): Bool {
    return getAccount(address)
        .getCapability<&{TopShot.MomentCollectionPublic}>(/public/MomentCollection)
        .check()
}

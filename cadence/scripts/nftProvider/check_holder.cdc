/**
 * Check is account has been initialized as NFT holder
 *
 * @param address flow account address
 */
import NonFungibleToken from "../../contracts/NonFungibleToken.cdc"

pub fun main(address: Address): Bool {
    let account = getAccount(address)
    return account.getCapability<&{NonFungibleToken.CollectionPublic}>(/public/NFTCollection).check()
}

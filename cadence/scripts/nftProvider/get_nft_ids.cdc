/**
 * Returns list of NFT ids has owned by address
 *
 * @param address flow account address
 */
import NonFungibleToken from 0xNONFUNGIBLETOKEN

pub fun main(address: Address): [UInt64] {
    let account = getAccount(address)
    let collection = account.getCapability<&{NonFungibleToken.CollectionPublic}>(/public/NFTCollection).borrow()
        ?? panic("Could not borrow reference (maybe account not initialized?)")
    return collection.getIDs()
}

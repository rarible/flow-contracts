/**
 * Returns NFTs data by id and address
 *
 * @param id NFT identifier
 * @param address flow account address
 */
import NonFungibleToken from "../../contracts/NonFungibleToken.cdc"

pub fun main(id: UInt64, address: Address): &NonFungibleToken.NFT {
    let account = getAccount(address)
    let collection = account.getCapability<&AnyResource{NonFungibleToken.CollectionPublic}>(/public/NFTCollection).borrow()
        ?? panic("Could not borrow reference (maybe account not initialized?)")
    return collection.borrowNFT(id: id)
}

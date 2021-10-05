import CommonNFT from "../../contracts/CommonNFT.cdc"

pub fun main(address: Address): [UInt64]? {
    let account = getAccount(address)
    let collection = CommonNFT.collectionPublic(address).borrow()!
    return collection.getIDs()
}

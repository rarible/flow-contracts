import CommonNFT from "../../contracts/CommonNFT.cdc"

pub fun main(address: Address, tokenId: UInt64): &AnyResource {
    let account = getAccount(address)
    let collection = CommonNFT.collectionPublic(address).borrow()!
    return collection.borrowNFT(id: tokenId)
}

import CommonNFT from 0xCOMMONNFT

pub fun main(address: Address, tokenId: UInt64): &AnyResource {
    let account = getAccount(address)
    let collection = CommonNFT.collectionPublic(address: address).borrow()!
    return collection.borrowNFT(id: tokenId)
}

import NonFungibleToken from 0xNONFUNGIBLETOKEN

pub contract interface NFTPlus {

    pub event Transfer(id: UInt64, from: Address?, to: Address)

    pub fun receiver(_ address: Address): Capability<&{NonFungibleToken.Receiver}>
    pub fun collectionPublic(_ address: Address): Capability<&{NonFungibleToken.CollectionPublic}>

    pub struct Royalties {
        pub let address: Address
        pub let fee: UFix64
    }

    pub resource interface WithRoyalties {
        pub fun getRoyalties(): [Royalties]
    }

    pub resource interface Transferable {
        pub fun transfer(tokenId: UInt64, to: Capability<&{NonFungibleToken.Receiver}>)
    }
}

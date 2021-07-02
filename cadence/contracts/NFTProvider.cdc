import NonFungibleToken from "NonFungibleToken.cdc"

pub contract NFTProvider: NonFungibleToken {

    pub var totalSupply: UInt64

    pub event ContractInitialized()
    pub event Withdraw(id: UInt64, from: Address?)
    pub event Deposit(id: UInt64, to: Address?)
    pub event Mint(id: UInt64, to: Address?)
    pub event Destroy(id: UInt64)

    pub struct Royalties {
        pub let address: Address
        pub let fee: UInt8

        init(address: Address, fee: UInt8) {
            self.address = address
            self.fee = fee
        }
    }

    pub struct Metadata {
        pub let uri: String
        pub let title: String
        pub let description: String
        pub let data: [UInt8]
        pub let properties: {String: String}

        init(uri: String, title: String, description: String?, data: [UInt8], properties: {String: String}) {
            self.uri = uri
            self.title = title
            self.description = description ?? "" // todo replace empty string with nil
            self.data = data
            self.properties = properties
        }
    }

    pub resource NFT: NonFungibleToken.INFT {
        pub let id: UInt64
        pub let collection: String
        pub let creator: Address
        pub let createDate: UFix64
        pub let royalties: [Royalties]
        pub let metadata: Metadata

        init(id: UInt64, collection: String, creator: Address, createDate: UFix64, royalties: [Royalties], metadata: Metadata) {
            self.id = id
            self.collection = collection
            self.creator = creator
            self.createDate = createDate
            self.royalties = royalties
            self.metadata = metadata
        }

        destroy() {
            emit Destroy(id: self.id)
        }
    }

    pub resource Collection: NonFungibleToken.Provider, NonFungibleToken.Receiver, NonFungibleToken.CollectionPublic {
        // dictionary of NFT conforming tokens
        // NFT is a resource type with an `UInt64` ID field
        pub var ownedNFTs: @{UInt64: NonFungibleToken.NFT}

        init () {
            self.ownedNFTs <- {}
        }

        // withdraw removes an NFT from the collection and moves it to the caller
        pub fun withdraw(withdrawID: UInt64): @NonFungibleToken.NFT {
            let token <- self.ownedNFTs.remove(key: withdrawID) ?? panic("missing NFT")

            emit Withdraw(id: token.id, from: self.owner?.address)

            return <-token
        }

        // deposit takes a NFT and adds it to the collections dictionary
        // and adds the ID to the id array
        pub fun deposit(token: @NonFungibleToken.NFT) {
            let token <- token as! @NFTProvider.NFT

            let id: UInt64 = token.id

            // add the new token to the dictionary which removes the old one
            let oldToken <- self.ownedNFTs[id] <- token

            emit Deposit(id: id, to: self.owner?.address)

            destroy oldToken
        }

        // getIDs returns an array of the IDs that are in the collection
        pub fun getIDs(): [UInt64] {
            return self.ownedNFTs.keys
        }

        // borrowNFT gets a reference to an NFT in the collection
        // so that the caller can read its metadata and call its methods
        pub fun borrowNFT(id: UInt64): &NonFungibleToken.NFT {
            return &self.ownedNFTs[id] as &NonFungibleToken.NFT
        }

        destroy() {
            destroy self.ownedNFTs
        }
    }

    // public function that anyone can call to create a new empty collection
    pub fun createEmptyCollection(): @NonFungibleToken.Collection {
        return <- create Collection()
    }

    pub resource interface Minter {
        pub fun mint(collection: String, creator: Address, createDate: UFix64, royalties: [Royalties], metadata: Metadata): @NonFungibleToken.NFT
    }

    // Resource that an admin or something similar would own to be
    // able to mint new NFTs
    //
    pub resource NFTMinter : Minter {

        pub fun mint(collection: String, creator: Address, createDate: UFix64, royalties: [Royalties], metadata: Metadata): @NonFungibleToken.NFT {
            let nft <- create NFT(
                id: NFTProvider.totalSupply,
                collection: collection,
                creator: creator,
                createDate: createDate,
                royalties: royalties,
                metadata: metadata
            )
            NFTProvider.totalSupply = NFTProvider.totalSupply + 1 as UInt64
            emit Mint(id: nft.id, to: creator)
            return <-nft
        }
    }

    pub fun minterAddress():Address {
        return self.account.address
    }

    init() {
        // Initialize the total supply
        self.totalSupply = 0

        // Create a Collection resource and save it to storage
        let collection <- create Collection()
        self.account.save(<-collection, to: /storage/NFTCollection)

        // create a public capability for the collection
        self.account.link<&{NonFungibleToken.CollectionPublic}>(
            /public/NFTCollection,
            target: /storage/NFTCollection
        )

        // Create a Minter resource and save it to storage
        let minter <- create NFTMinter()
        self.account.save(<-minter, to: /storage/NFTMinter)

        self.account.link<&{Minter}>(
            /public/Minter,
            target: /storage/NFTMinter
        )

        emit ContractInitialized()
    }
}

import NonFungibleToken from 0xNONFUNGIBLETOKEN
import NFTPlus from 0xNFTPLUS

/**
 * CommonNFT token contract
 */
pub contract CommonNFT : NonFungibleToken, NFTPlus {

    pub var totalSupply: UInt64

    pub var collectionPublicPath: PublicPath
    pub var collectionStoragePath: StoragePath
    pub var minterPublicPath: PublicPath
    pub var minterStoragePath: StoragePath
    pub var draftBoxPublicPath: PublicPath
    pub var draftBoxStoragePath: StoragePath

    pub event ContractInitialized()
    pub event Withdraw(id: UInt64, from: Address?)
    pub event Deposit(id: UInt64, to: Address?)

    pub event Mint(id: UInt64, collection: String, creator: Address, metadata: String, royalties: [NFTPlus.Royalties])
    pub event Destroy(id: UInt64)
    pub event Transfer(id: UInt64, from: Address?, to: Address)

    pub event WithdrawDraft(id: UInt64, from: Address?)
    pub event DepositDraft(id: UInt64, to: Address?)

    pub event MintDraft(id: UInt64, creator: Address, royalties: [NFTPlus.Royalties])
    pub event DestroyDraft(id: UInt64)

    pub struct Royalties {
        pub let address: Address
        pub let fee: UFix64

        init(address: Address, fee: UFix64) {
            self.address = address
            self.fee = fee
        }
    }

    pub resource Draft {
        pub let id: UInt64
        pub let creator: Address
        pub let royalties: [NFTPlus.Royalties]

        init(id: UInt64, creator: Address, royalties: [NFTPlus.Royalties]) {
            self.id = id
            self.creator = creator
            self.royalties = royalties
        }

        destroy() {
            emit DestroyDraft(id: self.id)
        }
    }

    pub resource NFT: NonFungibleToken.INFT, NFTPlus.WithRoyalties {
        pub let id: UInt64
        pub let creator: Address
        pub let metadata: String
        pub let royalties: [NFTPlus.Royalties]

        init(id: UInt64, creator: Address, metadata: String, royalties: [NFTPlus.Royalties]) {
            self.id = id
            self.creator = creator
            self.metadata = metadata
            self.royalties = royalties
        }

        destroy() {
            emit Destroy(id: self.id)
        }
    }

    pub resource Collection: NonFungibleToken.Provider, NonFungibleToken.Receiver, NonFungibleToken.CollectionPublic, NFTPlus.Transferable {
        pub var ownedNFTs: @{UInt64: NonFungibleToken.NFT}

        init() {
            self.ownedNFTs <- {}
        }

        pub fun withdraw(withdrawID: UInt64): @NonFungibleToken.NFT {
            let token <- self.ownedNFTs.remove(key: withdrawID) ?? panic("Missing NFT")
            emit Withdraw(id: token.id, from: self.owner?.address)
            return <- token
        }

        pub fun deposit(token: @NonFungibleToken.NFT) {
            let token <- token as! @CommonNFT.NFT
            let id: UInt64 = token.id
            let dummy <- self.ownedNFTs[id] <- token
            destroy dummy
            emit Deposit(id: id, to: self.owner?.address)
        }

        pub fun transfer(tokenId: UInt64, to: Capability<&{NonFungibleToken.Receiver}>) {
            let token <- self.ownedNFTs.remove(key: tokenId) ?? panic("Missed NFT")
            emit Withdraw(id: tokenId, from: self.owner?.address)
            to.borrow()!.deposit(token: <- token)
            emit Transfer(id: tokenId, from: self.owner?.address, to: to.address)
        }

        pub fun getIDs(): [UInt64] {
            return self.ownedNFTs.keys
        }

        pub fun borrowNFT(id: UInt64): &NonFungibleToken.NFT {
            return &self.ownedNFTs[id] as &NonFungibleToken.NFT
        }

        destroy() {
            destroy self.ownedNFTs
        }
    }

    pub fun createEmptyCollection(): @NonFungibleToken.Collection {
        return <- create Collection()
    }

    pub resource DraftBox {
        pub var drafts: @{UInt64:Draft}

        init() {
            self.drafts <- {}
        }

        access(contract) fun add(draft: @Draft) {
            let id = draft.id
            let dummy <- self.drafts[id] <- draft
            destroy dummy
            emit DepositDraft(id: id, to: self.owner?.address)
        }

        access(contract) fun get(id: UInt64): @Draft {
            let draft <- self.drafts.remove(key: id) ?? panic("Missing draft")
            emit WithdrawDraft(id: draft.id, from: self.owner?.address)
            return <- draft
        }

        destroy() {
            destroy self.drafts
        }
    }

    pub resource Minter {
        pub fun mint(creator: Address, metadata: String, royalties: [NFTPlus.Royalties]): @NonFungibleToken.NFT {
            let token <- create NFT(
                id: CommonNFT.totalSupply,
                creator: creator,
                metadata: metadata,
                royalties: royalties
            )
            CommonNFT.totalSupply = CommonNFT.totalSupply + 1
            emit Mint(id: token.id, collection: token.getType().identifier, creator: creator, metadata: metadata, royalties: royalties)
            return <- token
        }

        pub fun mintTo(creator: Capability<&{NonFungibleToken.Receiver}>, metadata: String, royalties: [NFTPlus.Royalties]): &NonFungibleToken.NFT {
            let token <- create NFT(
                id: CommonNFT.totalSupply,
                creator: creator.address,
                metadata: metadata,
                royalties: royalties
            )
            CommonNFT.totalSupply = CommonNFT.totalSupply + 1
            let tokenRef = &token as &NonFungibleToken.NFT
            emit Mint(id: token.id, collection: token.getType().identifier, creator: creator.address, metadata: metadata, royalties: royalties)
            creator.borrow()!.deposit(token: <- token)
            return tokenRef
        }

        pub fun mintDraft(creator: Address, royalties: [NFTPlus.Royalties]) {
            let draft <- create Draft(
                id: CommonNFT.totalSupply,
                creator: creator,
                royalties: royalties
            )
            CommonNFT.totalSupply = CommonNFT.totalSupply + 1
            emit MintDraft(id: draft.id, creator: draft.creator, royalties: draft.royalties)
            CommonNFT.draftBox(creator).borrow()!.add(draft: <- draft)
        }

        pub fun mintItem(tokenId: UInt64, creator: Address, metadata: String): &NonFungibleToken.NFT {
            let draft <- CommonNFT.draftBox(creator).borrow()!.get(id: tokenId)
            let token <- create NFT(
                id: draft.id,
                creator: draft.creator,
                metadata: metadata,
                royalties: draft.royalties
            )
            let tokenRef = &token as &NonFungibleToken.NFT
            emit Mint(id: token.id, collection: token.getType().identifier, creator: draft.creator, metadata: metadata, royalties: draft.royalties)
            CommonNFT.receiver(creator).borrow()!.deposit(token: <- token)
            destroy draft
            return tokenRef
        }
    }

    pub fun configureAccount(_ account: AuthAccount): &Collection {
        let collection <- self.createEmptyCollection() as! @Collection
        let ref = &collection as &Collection
        account.save(<- collection, to: self.collectionStoragePath)
        account.link<&{NonFungibleToken.CollectionPublic,NonFungibleToken.Receiver}>(self.collectionPublicPath, target: self.collectionStoragePath)

        let draftBox <- create DraftBox()
        account.save(<- draftBox, to: self.draftBoxStoragePath)
        account.link<&DraftBox>(self.draftBoxPublicPath, target: self.draftBoxStoragePath)

        return ref
    }

    pub fun cleanAccount(_ account: AuthAccount) {
        account.unlink(self.collectionPublicPath)
        destroy <- account.load<@Collection>(from: self.collectionStoragePath)
        account.unlink(self.draftBoxPublicPath)
        destroy <- account.load<@DraftBox>(from: self.draftBoxStoragePath)
    }

    pub fun collectionRef(_ account: AuthAccount): &Collection {
        return account.borrow<&Collection>(from: self.collectionStoragePath) ?? self.configureAccount(account)
    }

    pub fun receiver(_ address: Address): Capability<&{NonFungibleToken.Receiver}> {
        return getAccount(address).getCapability<&{NonFungibleToken.Receiver}>(self.collectionPublicPath)
    }

    pub fun collectionPublic(_ address: Address): Capability<&{NonFungibleToken.CollectionPublic}> {
        return getAccount(address).getCapability<&{NonFungibleToken.CollectionPublic}>(self.collectionPublicPath)
    }

    pub fun minter(): Capability<&Minter> {
        return self.account.getCapability<&Minter>(self.minterPublicPath)
    }

    pub fun draftBox(_ address: Address): Capability<&DraftBox> {
        return getAccount(address).getCapability<&DraftBox>(self.draftBoxPublicPath)
    }

    pub fun deinit(_ account: AuthAccount) {
        account.unlink(self.minterPublicPath)
        destroy <- account.load<@AnyResource>(from: self.minterStoragePath)

        account.unlink(self.collectionPublicPath)
        destroy <- account.load<@AnyResource>(from: self.collectionStoragePath)
    }

    init() {
        self.totalSupply = 0 // not used
        self.collectionPublicPath = /public/CommonNFTCollection
        self.collectionStoragePath = /storage/CommonNFTCollection
        self.minterPublicPath = /public/CommonNFTMinter
        self.minterStoragePath = /storage/CommonNFTMinter
        self.draftBoxPublicPath = /public/CommonNFTDraftBox
        self.draftBoxStoragePath = /storage/CommonNFTDraftBox

        let minter <- create Minter()
        self.account.save(<- minter, to: self.minterStoragePath)
        self.account.link<&Minter>(self.minterPublicPath, target: self.minterStoragePath)

        let collection <- self.createEmptyCollection()
        self.account.save(<- collection, to: self.collectionStoragePath)
        self.account.link<&{NonFungibleToken.CollectionPublic,NonFungibleToken.Receiver}>(self.collectionPublicPath, target: self.collectionStoragePath)

        let draftBox <- create DraftBox()
        self.account.save(<- draftBox, to: self.draftBoxStoragePath)
        self.account.link<&DraftBox>(self.draftBoxPublicPath, target: self.draftBoxStoragePath)

        emit ContractInitialized()
    }
}

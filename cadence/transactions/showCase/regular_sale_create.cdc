/**
 * Create regular sale on signer account for flow
 * Account must be initialized with ShowCase
 *
 * @param tokenId: NFT id for sale
 * @param amount: NFT price in flow
 */
import RegularSaleOrder from 0xREGULARSALEORDER
import NonFungibleToken from 0xNONFUNGIBLETOKEN
import FungibleToken from 0xFUNGIBLETOKEN
import StoreShowCase from 0xSTORESHOWCASE
import AssetBound from 0xASSETBOUND
import FlowToken from 0xFLOWTOKEN
import FtPathMapper from 0xFTPATHMAPPER
import CommonNFT from 0xCOMMONNFT

transaction(tokenId: UInt64, amount: UFix64) {

    let nft: @NonFungibleToken.NFT
    let showCase: &StoreShowCase.ShowCase
    let receiver: Capability<&{FungibleToken.Receiver}>

    prepare(signer: AuthAccount) {
        if signer.borrow<&CommonNFT.Collection>(from: CommonNFT.collectionStoragePath) == nil {
            let collection <- CommonNFT.createEmptyCollection() as! @CommonNFT.Collection
            signer.save(<- collection, to: CommonNFT.collectionStoragePath)
            signer.link<&{NonFungibleToken.CollectionPublic,NonFungibleToken.Receiver}>(CommonNFT.collectionPublicPath, target: CommonNFT.collectionStoragePath)
        }

        let collection = signer.borrow<&CommonNFT.Collection>(from: CommonNFT.collectionStoragePath)!!
        self.nft <- collection.withdraw(withdrawID: tokenId)
        self.showCase = StoreShowCase.showCase(signer)
        self.receiver = FtPathMapper.getReceiver(type: Type<&FlowToken.Vault>(), address: signer.address)
    }

    execute {
        let bound = AssetBound.createFtBound(type: Type<@FlowToken.Vault>(), amount: amount)
        let order <- RegularSaleOrder.createOrder(ask: <- self.nft, bid: bound, receiver: self.receiver)
        self.showCase.add(order: <- order)
    }
}

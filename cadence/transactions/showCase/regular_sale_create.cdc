/**
 * Create regular sale on signer account for flow
 * Account must be initialized with ShowCase
 *
 * @param tokenId: NFT id for sale
 * @param amount: NFT price in flow
 */
import RegularSaleOrder from 0xREGULARSALEORDERADDRESS
import NonFungibleToken from 0xNONFUNGIBLETOKENADDRESS
import FungibleToken from 0xFUNGIBLETOKENADDRESS
import StoreShowCase from 0xSTORESHOWCASEADDRESS
import AssetBound from 0xASSETBOUNDADDRESS
import FlowToken from 0xFLOWTOKENADDRESS
import FtPathMapper from 0xFTPATHMAPPERADDRESS

transaction(tokenId: UInt64, amount: UFix64) {

    let nft: @NonFungibleToken.NFT
    let showCase: &StoreShowCase.ShowCase
    let receiver: Capability<&{FungibleToken.Receiver}>

    prepare(signer: AuthAccount) {
        let sender = signer.borrow<&{NonFungibleToken.Provider}>(from: /storage/NFTCollection)
            ?? panic("Could not borrow sender reference")
        self.nft <- sender.withdraw(withdrawID: tokenId)
        self.showCase = signer.borrow<&StoreShowCase.ShowCase>(from: StoreShowCase.storeShowCaseStoragePath)!
        self.receiver = FtPathMapper.getReceiver(type: Type<&FlowToken.Vault>(), address: signer.address)
    }

    execute {
        let bound = AssetBound.createFtBound(type: Type<@FlowToken.Vault>(), amount: amount)
        let order <- RegularSaleOrder.createOrder(ask: <- self.nft, bid: bound, receiver: self.receiver)
        self.showCase.add(order: <- order)
    }
}

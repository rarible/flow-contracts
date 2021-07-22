/**
 * Create regular sale on signer account for flow
 * Account must be initialized with ShowCase
 *
 * @param sellerAddress: seller address
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

transaction(sellerAddress: Address, saleId: UInt64, amount: UFix64) {

    let showCase: &{StoreShowCase.ShowCasePublic}
    let receiver: &{NonFungibleToken.CollectionPublic}
    let vault: @FungibleToken.Vault

    prepare(signer: AuthAccount) {
        let provider = signer.borrow<&{FungibleToken.Provider}>(from: FtPathMapper.storage[Type<&FlowToken.Vault>().identifier]!)!
        self.vault <- provider.withdraw(amount: amount)

        let seller = getAccount(sellerAddress)
        self.showCase = seller.getCapability<&{StoreShowCase.ShowCasePublic}>(StoreShowCase.storeShowCasePublicPath).borrow()
            ?? panic("Could not borrow showCase reference")
        self.receiver = signer.getCapability<&{NonFungibleToken.CollectionPublic}>(/public/NFTCollection).borrow()
            ?? panic("Could not borrow receiver reference")
    }

    execute {
        let item <- self.showCase.close(id: saleId, item: <- self.vault)!
        let product <- item as! @NonFungibleToken.NFT
        self.receiver.deposit(token: <- product)
    }
}

/**
 * Cancel regular sale on signer account for flow
 * Account must be initialized with ShowCase
 *
 * @param saleId: sale id for sale
 */
import NonFungibleToken from 0xNONFUNGIBLETOKEN
import FungibleToken from 0xFUNGIBLETOKEN
import StoreShowCase from 0xSTORESHOWCASE
import CommonNFT from 0xCOMMONNFT

transaction(saleId: UInt64) {

    let showCase: &StoreShowCase.ShowCase
    let receiver: &{NonFungibleToken.Receiver}

    prepare(signer: AuthAccount) {
        self.showCase = signer.borrow<&StoreShowCase.ShowCase>(from: StoreShowCase.storeShowCaseStoragePath)!
        self.receiver = CommonNFT.receiver(address: signer.address).borrow()!
    }

    execute {
        let order <- self.showCase.withdraw(id: saleId)
        let item <- order.withdraw()!
        destroy order

        let nft <- item as! @NonFungibleToken.NFT
        self.receiver.deposit(token: <- nft)
    }
}

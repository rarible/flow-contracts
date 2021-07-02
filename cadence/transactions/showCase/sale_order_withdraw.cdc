/**
 * Cancel regular sale on signer account for flow
 * Account must be initialized with ShowCase
 *
 * @param saleId: sale id for sale
 */
import NonFungibleToken from "../../contracts/NonFungibleToken.cdc"
import FungibleToken from "../../contracts/FungibleToken.cdc"
import StoreShowCase from "../../contracts/StoreShowCase.cdc"

transaction(saleId: UInt64) {

    let showCase: &StoreShowCase.ShowCase
    let receiver: &{NonFungibleToken.CollectionPublic}

    prepare(signer: AuthAccount) {
        self.showCase = signer.borrow<&StoreShowCase.ShowCase>(from: StoreShowCase.storeShowCaseStoragePath)!
        self.receiver = signer.getCapability<&{NonFungibleToken.CollectionPublic}>(/public/NFTCollection).borrow()
            ?? panic("Could not borrow receiver reference")
    }

    execute {
        let order <- self.showCase.withdraw(id: saleId)
        let item <- order.withdraw()!
        destroy order

        let nft <- item as! @NonFungibleToken.NFT
        self.receiver.deposit(token: <- nft)
    }
}

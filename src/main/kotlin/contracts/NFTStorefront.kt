package contracts

import Context
import util.Account
import util.ContractWrapper
import util.SourceConverter

class NFTStorefront(override val context: Context, override val converter: SourceConverter) : ContractWrapper {
    override val prefix: String = "nftStorefront"

    fun getFees() = sc("get_fees")

    fun setFees(account: Account, sellerFee: Double, buyerFee: Double) =
        tx(account, "set_fees") {
            arg { ufix64(sellerFee) }
            arg { ufix64(buyerFee) }
        }

    fun setupAccount(account: Account) = tx(account, "setup_account")

    fun readStorefrontIds(address: String) = sc("read_storefront_ids") {
        arg { address(address) }
    }

    fun readSaleOfferDetails(address: String, saleOfferResourceId: ULong) =
        sc("read_sale_offer_details") {
            arg { address(address) }
            arg { uint64(saleOfferResourceId) }
        }

    fun sellItem(account: Account, saleItemId: ULong, saleItemPrice: Double) =
        tx(account, "sell_item") {
            arg { uint64(saleItemId) }
            arg { ufix64(saleItemPrice) }
        }

    fun buyItem(account: Account, saleOfferResourceId: ULong, storefrontAddress: String) =
        tx(account, "buy_item") {
            arg { uint64(saleOfferResourceId) }
            arg { address(storefrontAddress) }
        }

    fun cleanupItem(account: Account, saleOfferResourceId: ULong, storefrontAddress: String) =
        tx(account, "cleanup_item") {
            arg { uint64(saleOfferResourceId) }
            arg { address(storefrontAddress) }
        }

    fun removeItem(account: Account, saleOfferResourceId: ULong) =
        tx(account, "remove_item") {
            arg { uint64(saleOfferResourceId) }
        }
}

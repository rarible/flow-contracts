package contracts

import Context
import util.Account
import util.ContractWrapper
import util.SourceConverter

class StoreShowCase(override val context: Context, override val converter: SourceConverter) : ContractWrapper {
    override val prefix = "showCase"

    fun getSaleIds(address: String) =
        sc("get_sale_ids") {
            arg { address(address) }
        }

    fun saleDetails(id: ULong, address: String) =
        sc("sale_details") {
            arg { uint64(id) }
            arg { address(address) }
        }

    fun initShowCase(account: Account) =
        tx(account, "init_show_case")

    fun clean(account: Account) =
        tx(account, "clean")

    fun regularSaleCreate(account: Account, tokenId: ULong, amount: Double) =
        tx(account, "regular_sale_create") {
            arg { uint64(tokenId) }
            arg { ufix64(amount) }
        }

    fun regularSalePurchase(account: Account, sellerAddress: String, saleId: ULong) =
        tx(account, "regular_sale_purchase") {
            arg { address(sellerAddress) }
            arg { uint64(saleId) }
        }

    fun saleOrderWithdraw(account: Account, saleId: ULong) =
        tx(account, "sale_order_withdraw") {
            arg { uint64(saleId) }
        }
}
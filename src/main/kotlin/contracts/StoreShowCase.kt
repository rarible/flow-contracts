package contracts

import Account
import ContractWrapper
import SourceConverter
import org.onflow.sdk.FlowAccessApi

class StoreShowCase(override val api: FlowAccessApi, override val converter: SourceConverter) : ContractWrapper {
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

    fun regularSaleCreateExt(account: Account, tokenId: ULong, amount: Double) =
        tx(account, "regular_sale_create_ext") {
            arg { uint64(tokenId) }
            arg { ufix64(amount) }
        }

    fun regularSalePurchase(account: Account, sellerAddress: String, saleId: ULong, amount: Double) =
        tx(account, "regular_sale_purchase") {
            arg { address(sellerAddress) }
            arg { uint64(saleId) }
            arg { ufix64(amount) }
        }

    fun regularSalePurchaseExt(account: Account, sellerAddress: String, saleId: ULong) =
        tx(account, "regular_sale_purchase_ext") {
            arg { address(sellerAddress) }
            arg { uint64(saleId) }
        }

    fun saleOrderWithdraw(account: Account, saleId: ULong) =
        tx(account, "sale_order_withdraw") {
            arg { uint64(saleId) }
        }
}
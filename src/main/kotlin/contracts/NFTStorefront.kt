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
}

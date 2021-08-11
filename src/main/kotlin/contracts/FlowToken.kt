package contracts

import Context
import util.Account
import util.ContractWrapper
import util.SourceConverter

class FlowToken(override val context: Context, override val converter: SourceConverter) : ContractWrapper {
    override val prefix = "flowToken"

    fun getBalance(address: String) =
        rsc("get_balance") {
            arg { address(address) }
        }

    fun transferFlow(account: Account, amount: Double, address: String) =
        rtx(account, "transfer_tokens") {
            arg { ufix64(amount) }
            arg { address(address) }
        }
}

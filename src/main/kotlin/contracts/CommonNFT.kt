package contracts

import Context
import util.Account
import util.ContractWrapper
import util.SourceConverter
import util.asBoolean

class CommonNFT(override val context: Context, override val converter: SourceConverter) : ContractWrapper {
    override val prefix = "commonNft"

    fun check(address: String) = sc("check", address) {
        arg { address(address) }
    }.asBoolean()

    fun getIds(address: String) = sc("get_ids", address) {
        arg { address(address) }
    }

    fun borrowNft(address: String, tokenId: ULong) = sc("borrow_nft", address, tokenId) {
        arg { address(address) }
        arg { uint64(tokenId) }
    }

    fun mint(account: Account, metadata: String, royalties: Map<String, Double>) = tx(account, "mint") {
        val commonNftAddress = context.contracts.deployAddresses["CommonNFT"]!!.drop(2)
        arg { string(metadata) }
        arg {
            array {
                royalties.map { (k, v) ->
                    struct(
                        composite(
                            "A.$commonNftAddress.CommonNFT.Royalties",
                            listOf("address" to address(k), "fee" to ufix64(v))
                        )
                    )
                }
            }
        }
    }

    fun transfer(account: Account, tokenId: ULong, address: String) = tx(account, "transfer") {
        arg { uint64(tokenId) }
        arg { address(address) }
    }

    fun burn(account: Account, tokenId: ULong) = tx(account, "burn") {
        arg { uint64(tokenId) }
    }

    fun clean(account: Account) = tx(account, "clean")

    fun init(account: Account) = tx(account, "init")

    fun mrproper(account: Account) = tx(account, "mrproper")
}
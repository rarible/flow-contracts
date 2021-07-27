package contracts

import Account
import ContractWrapper
import SourceConverter
import org.onflow.sdk.FlowAccessApi

class CommonNFT(override val api: FlowAccessApi, override val converter: SourceConverter) : ContractWrapper {
    override val prefix = "commonNft"

    fun check(address: String) = sc("check", address) {
        arg { address(address) }
    }

    fun getIds(address: String) = sc("get_ids", address) {
        arg { address(address) }
    }

    fun borrowNft(address: String, tokenId: ULong) = sc("borrow_nft", address, tokenId) {
        arg { address(address) }
        arg { uint64(tokenId) }
    }

    fun mint(account: Account, metadata: String, royalties: Map<String, Double>) = tx(account, "mint") {
        arg { string(metadata) }
        arg {
            array {
                royalties.map { (k, v) ->
                    val s = struct(
                        composite(
                            "A.f8d6e0586b0a20c7.CommonNFT.Royalties",
                            listOf(
                                "address" to address(k),
                                "fee" to ufix64(v),
                            )
                        )
                    )
                    s
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
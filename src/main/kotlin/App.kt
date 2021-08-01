import contracts.CommonNFT
import contracts.FlowToken
import contracts.StoreShowCase
import org.onflow.sdk.*
import org.onflow.sdk.cadence.AddressField
import org.onflow.sdk.cadence.Field
import org.onflow.sdk.cadence.OptionalField
import org.onflow.sdk.cadence.UInt64NumberField

class App {
    companion object {
        private val emulatorCoreContracts = mapOf(
            "FlowFees" to "0xe5a8b7f23e8b548f",
            "FlowServiceAccount" to "0xf8d6e0586b0a20c7",
            "FlowStorageFees" to "0xf8d6e0586b0a20c7",
            "FlowToken" to "0x0ae53cb6e3f42a79",
            "FungibleToken" to "0xee82856bf20e2aa6",
        )

        @JvmStatic
        fun main(args: Array<String>) {
            val api = Flow.newAccessApi("localhost", 3569)
            val existingAccounts = listOf(
                Accounts.AccountDef(
                    "service",
                    "0xf8d6e0586b0a20c7",
                    "ed0d199902395428026e5055bfeaa7e823c5e1da978b3088dc6ef11ee74f4503526db91baca581dd0de140a0cab8a6234b01e9b5849dd941b556999f3c1eed16",
                    "ba412c8efe86d806da91ad655bf2c6bcf8fa1c8f8a2bb5cdd0de43fcaab1a2f9"
                )
            )
            val accounts = Accounts(
                api,
                existingAccounts,
                listOf("alice", "bob", "eve")
            )
            val contracts = Contracts(
                "cadence", "contracts", emulatorCoreContracts, mapOf(
                    "0xf8d6e0586b0a20c7" to listOf(
                        "NonFungibleToken",
                        "NFTProvider",
                        "SaleOrder",
                        "RegularSaleOrder",
                        "AssetBound",
                        "MarketFee",
                        "StoreShowCase",
                        "FtPathMapper",
                        "NFTPlus",
                        "CommonNFTDraft",
                        "CommonNFT",
                    )
                ).flatMap { (address, contracts) -> contracts.map { it to address } }.toMap()
            )
            contracts.saveSedConfig()
            val deployScheme = DeployScheme(api, contracts, accounts)
            deployScheme.deploy()
            val service = accounts.serviceAccount
            val alice = accounts.accounts["alice"]!!
            val bob = accounts.accounts["bob"]!!
            val eve = accounts.accounts["eve"]!!

            val converter = SourceConverter(emulatorCoreContracts + contracts.deployAddresses)
            val flowToken = FlowToken(api, converter)
            val commonNFT = CommonNFT(api, converter)
            val showCase = StoreShowCase(api, converter)

            listOf(alice, bob, eve).forEach {
                commonNFT.init(it)
                flowToken.transferFlow(service, 10.0, it.addressHex)
                flowToken.getBalance(it.addressHex)
            }
            commonNFT.check(alice.addressHex)
            commonNFT.getIds(alice.addressHex)
            commonNFT.check("0xf8d6e0586b0a20c7")
            commonNFT.getIds("0xf8d6e0586b0a20c7")


            val royalties = mapOf(
                alice.addressHex to 2.0,
                bob.addressHex to 3.0,
                eve.addressHex to 5.0,
            )
            val draftId = commonNFT.mintS1(service, alice.addressHex, royalties)
                .e("CommonNFT.MintDraft")!!.field("id").asULong()
            val tokenId = commonNFT.mintS2(service, draftId, alice.addressHex, "ipfs://metadata")
                .e("CommonNFT.Mint")!!.field("id").asULong()
            commonNFT.getIds(alice.addressHex)
            val draftId2 = commonNFT.mintS1(alice, alice.addressHex, royalties)
                .e("CommonNFT.MintDraft")!!.field("id").asULong()
            val tokenId2 = commonNFT.mintS2(service, draftId2, alice.addressHex, "ipfs://metadata")
                .e("CommonNFT.Mint")!!.field("id").asULong()
            commonNFT.getIds(alice.addressHex)
//            val tokenId = commonNFT.mint(accounts.serviceAccount, "Hello, world!", mapOf(
//                alice.addressHex to 2.0,
//                bob.addressHex to 3.0,
//                eve.addressHex to 5.0,
//            )).e("CommonNFTDraft.Mint")!!.field("id").asULong()
//            val tokenId = commonNFT.mint(accounts.serviceAccount, "Hello, world!", mapOf(
//                alice.addressHex to 2.0,
//                bob.addressHex to 3.0,
//                eve.addressHex to 5.0,
//            )).e("CommonNFT.Mint")!!.field("id").asULong()
            commonNFT.borrowNft(alice.addressHex, tokenId)
//            commonNFT.transfer(accounts.serviceAccount, 1U, accounts.serviceAccount.address.formatted)
//            val r4 = commonNFT.burn(accounts.serviceAccount, 5U)
//            println(r4)

//            showCase.getSaleIds(alice.addressHex)
            val saleId = showCase.regularSaleCreate(alice, tokenId, 0.2045)
                .e("RegularSaleOrder.OrderOpened")!!.field("id").asULong()
//            showCase.saleOrderWithdraw(service, saleId)
            val address = showCase.regularSalePurchaseExt(service, alice.addressHex, saleId)
                .e("CommonNFT.Deposit")!!.field("to").asAddress()
//            commonNFT.transfer(accounts.serviceAccount, 2U, alice.addressHex)
//            commonNFT.clean(alice)
//            println("tokenId: $tokenId, saleId: $saleId, address: address")
//            showCase.getSaleIds(service.addressHex).asULongArray()
        }
    }
}

private fun FlowScriptResponse.asULongArray() {
    TODO("Not yet implemented")
}

private fun Pair<FlowId, FlowTransactionResult>.e(s: String): FlowEvent? {
    return second.events.find { it.type.endsWith(s) }
}

private fun FlowEvent.field(name: String): Field<*> =
    event.value!!.fields.find { it.name == name }!!.value

private fun Field<*>.asULong() =
    (this as UInt64NumberField).value!!.toULong()

private fun Field<*>.asAddress() = (value as AddressField).value!!
private fun Field<*>.optional() = (value as OptionalField).value

private fun <T> FlowEvent.f(s: String): T {
    return event.value!!.fields.find { it.name == s }!!.value.value as T
}


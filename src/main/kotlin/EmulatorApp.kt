import util.addressValue
import util.asULongArray
import util.uLongValue

class EmulatorApp {
    companion object {
        @JvmStatic
        fun main(args: Array<String>) {
            val context = Context(Emulator, listOf("alice", "bob", "eve"))
//            context.contracts.saveSedConfig()
            context.deployScheme.deploy()

            val service = context.accounts.serviceAccount
            val alice = context.accounts.byName["alice"]!!
            val bob = context.accounts.byName["bob"]!!
            val eve = context.accounts.byName["eve"]!!
            val all = listOf(alice, bob, eve)

            context.nftStorefront.getFees()
            context.nftStorefront.setFees(service, 2.4, 2.6)

            all.forEach {
//                commonNFT.init(it)
                context.flowToken.transferFlow(service, 10.0, it.addressHex)
                context.flowToken.getBalance(it.addressHex)
            }
            context.commonNFT.check(alice.addressHex)
//            commonNFT.getIds(alice.addressHex)
            context.commonNFT.check(service.addressHex)
            context.commonNFT.getIds(service.addressHex)

            val royalties = mapOf(
                alice.addressHex to 2.0,
                bob.addressHex to 3.0,
                eve.addressHex to 5.0,
            )
            val tokenId = context.commonNFT.mint(alice, "ipfs://metadata", royalties)
                .uLongValue("CommonNFT.Mint", "id")!!
            context.commonNFT.borrowNft(alice.addressHex, tokenId)
            val res = context.commonNFT.getIds(alice.addressHex).asULongArray()
//            commonNFT.transfer(accounts.serviceAccount, 1U, accounts.serviceAccount.address.formatted)
//            val r4 = commonNFT.burn(accounts.serviceAccount, 5U)
//            println(r4)

//            showCase.getSaleIds(alice.addressHex)
            val saleId = context.showCase.regularSaleCreate(alice, tokenId, 0.2045)
                .uLongValue("RegularSaleOrder.OrderOpened", "id")!!
//            showCase.saleOrderWithdraw(service, saleId)
            val address = context.showCase.regularSalePurchase(service, alice.addressHex, saleId)
                .addressValue("CommonNFT.Deposit", "to")!!
//            commonNFT.transfer(accounts.serviceAccount, 2U, alice.addressHex)
//            commonNFT.clean(alice)
//            println("tokenId: $tokenId, saleId: $saleId, address: address")
//            showCase.getSaleIds(service.addressHex).util.asULongArray()
        }

    }
}

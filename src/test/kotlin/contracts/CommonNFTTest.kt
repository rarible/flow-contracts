package contracts

import Context
import Emulator
import org.junit.jupiter.api.Assertions.assertFalse
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.assertDoesNotThrow
import org.junit.jupiter.api.assertThrows
import org.onflow.sdk.FlowException
import org.onflow.sdk.cadence.*
import util.*
import kotlin.test.assertEquals
import kotlin.test.assertTrue

internal class CommonNFTTest {

    @Test
    fun check() {
        val c = Context(Emulator, listOf("alice", "bob", "eve")).apply { deployScheme.deploy() }
        val eve = c.accounts["eve"]!!
        assertFalse(c.commonNFT.check(eve.addressHex))
    }

    @Test
    fun init() {
        val c = Context(Emulator, listOf("alice", "bob", "eve")).apply { deployScheme.deploy() }
        val alice = c.accounts["alice"]!!
        c.commonNFT.init(alice)
        assertTrue(c.commonNFT.check(alice.addressHex))
    }

    @Test
    fun mint() {
        val c = Context(Emulator, listOf("alice", "bob", "eve")).apply { deployScheme.deploy() }

        fun Account.check() = c.commonNFT.check(addressHex)

        fun Account.init() = c.commonNFT.init(this)

        fun Account.mint(metadata: String, royalties: Map<String, Double>) =
            c.commonNFT.mint(this, metadata, royalties)
                .uLongValue("CommonNFT.Mint", "id")!!

        fun Account.burn(tokenId: ULong) =
            c.commonNFT.burn(this, tokenId)

        fun Account.borrowNft(tokenId: ULong) =
            c.commonNFT.borrowNft(addressHex, tokenId).jsonCadence.value as ResourceField

        fun Account.transfer(tokenId: ULong, to: Account) =
            c.commonNFT.transfer(this, tokenId, to.addressHex)

        fun Account.getIds() = c.commonNFT.getIds(addressHex).asULongArray()

        fun Account.sell(tokenId: ULong, amount: Double) =
            c.showCase.regularSaleCreate(this, tokenId, amount)
                .uLongValue("RegularSaleOrder.OrderOpened", "id")!!

        fun Account.buy(account: Account, saleId: ULong) =
            c.showCase.regularSalePurchase(this, account.addressHex, saleId)

        fun Account.borrowSale(saleId: ULong) =
            c.showCase.saleDetails(saleId, addressHex)

        fun Account.topUp(amount: Double) =
            c.flowToken.transferFlow(c.accounts["service"]!!, amount, addressHex)

        fun Account.getFees() = c.nftStorefront.getFees()
        fun Account.setFees(sellerFee: Double, buyerFee: Double) =
            c.nftStorefront.setFees(this, sellerFee, buyerFee)

        val service = c.accounts["service"]!!
        val alice = c.accounts["alice"]!!
        val bob = c.accounts["bob"]!!
        val eve = c.accounts["eve"]!!

        val metadata = "ipfs://metadata"
        val royalties = mapOf(alice.addressHex to 5.0, eve.addressHex to 3.0)

        // fee check
        assertDoesNotThrow {

            service.setFees(5.75, 3.25).apply {
                val sellerFee = (findField("CommonFee.SellerFeeChanged", "value") as UFix64NumberField).toDouble()
                assertEquals(5.75, sellerFee)
                val buyerFee = (findField("CommonFee.BuyerFeeChanged", "value") as UFix64NumberField).toDouble()
                assertEquals(3.25, buyerFee)
            }

            alice.getFees().apply {
                val actual = (jsonCadence.value as Array<*>)
                    .map { it as DictionaryFieldEntry }
                    .associate { (it.key as StringField).value!! to (it.value as UFix64NumberField).toDouble()!! }
                val expected = mapOf("sellerFee" to 5.75, "buyerFee" to 3.25)
                assertEquals(expected, actual)
            }

            service.setFees(2.5, 2.5)
        }

        // init and check
        assertDoesNotThrow {
            assertFalse(alice.check())
            alice.init()
            assertTrue(alice.check())
        }

        assertDoesNotThrow {
            // mint and check item attributes
            bob.apply {
                assertFalse(bob.check())
                val id = mint(metadata, royalties)
                assertTrue(bob.check(), "Init during mint")
                borrowNft(id).apply {
                    assertEquals(id, get<UInt64NumberField>("id")?.toULong())
                    assertEquals(addressHex, get<AddressField>("creator")?.value)
                    assertEquals(metadata, get<StringField>("metadata")?.value)
                    assertEquals(royalties, get<ArrayField>("royalties")?.toRoyalties())
                }
                assertTrue { getIds()!!.contains(id) }
            }

            // test transfer
            val tokenId = bob.getIds()!!.first()
            bob.transfer(tokenId, alice)
            assertTrue(alice.getIds()!!.contains(tokenId))
        }

        // transfer not owned item
        assertThrows<FlowException> {
            bob.transfer(0U, alice)
        }

        // borrow not owned item
        assertThrows<FlowException> {
            bob.borrowNft(0U)
        }

        // transfer to not initialized account
        assertThrows<FlowException> {
            val tokenId = bob.mint(metadata, royalties)
            bob.transfer(tokenId, eve)
        }

        // burn item
        assertDoesNotThrow {
            val tokenId = bob.mint(metadata, royalties)
            bob.burn(tokenId)
        }

        // burn a non-existent item
        assertThrows<FlowException> {
            bob.burn(0U)
        }

        // create sale
        val tokenId = assertDoesNotThrow { bob.mint(metadata, royalties) }
        val saleId = assertDoesNotThrow { bob.sell(tokenId, 0.123) }

        // try buy without enough money
        assertThrows<FlowException> {
            alice.buy(bob, saleId)
        }

        assertDoesNotThrow {
//            bob.borrowSale(saleId)
            alice.topUp(10.0)
            alice.buy(bob, saleId).also { (_, result) ->
                val eveAmount = result.events
                    .find {
                        it.type.endsWith("FlowToken.TokensDeposited") &&
                                it.get<OptionalField>("to")?.value?.value == eve.addressHex
                    }
                    ?.let { it.get<UFix64NumberField>("amount")?.toDouble() }
                println("eveAmount = $eveAmount")
            }
            alice.getIds()
        }
    }
}

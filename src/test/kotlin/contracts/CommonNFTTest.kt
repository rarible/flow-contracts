package contracts

import Context
import Emulator
import com.nftco.flow.sdk.FlowException
import com.nftco.flow.sdk.cadence.*
import org.junit.jupiter.api.Assertions.assertFalse
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.assertDoesNotThrow
import org.junit.jupiter.api.assertThrows
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

        fun Account.topUp(amount: Double) =
            c.flowToken.transferFlow(c.accounts["service"]!!, amount, addressHex)

        fun Account.getFees() = c.nftStorefront.getFees()
        fun Account.setFees(sellerFee: Double, buyerFee: Double) =
            c.nftStorefront.setFees(this, sellerFee, buyerFee)

        fun Account.readStorefrontIds() =
            c.nftStorefront.readStorefrontIds(addressHex).asULongArray()

        fun Account.readSaleOfferDetails(saleOfferResourceId: ULong) =
            c.nftStorefront.readSaleOfferDetails(addressHex, saleOfferResourceId)

        fun Account.setupAccount() =
            c.nftStorefront.setupAccount(this)

        fun Account.sellItem(saleItemId: ULong, saleItemPrice: Double) =
            c.nftStorefront.sellItem(this, saleItemId, saleItemPrice)

        fun Account.buyItem(saleOfferRecourceId: ULong, storefrontAddress: String) =
            c.nftStorefront.buyItem(this, saleOfferRecourceId, storefrontAddress)

        fun Account.cleanupItem(saleOfferResourceId: ULong, storefrontAddress: String) =
            c.nftStorefront.cleanupItem(this, saleOfferResourceId, storefrontAddress)

        fun Account.removeItem(saleOfferResourceId: ULong) =
            c.nftStorefront.removeItem(this, saleOfferResourceId)

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

        alice.topUp(10.0)
        bob.topUp(10.0)

        assertDoesNotThrow {
            alice.setupAccount()
            val id = alice.mint(metadata, royalties)
            alice.sellItem(id, 1.00)
            val buyId = alice.readStorefrontIds()!!.first()
//            alice.readSaleOfferDetails(buyId)
            bob.buyItem(buyId, alice.addressHex)
            bob.cleanupItem(buyId, alice.addressHex)
        }

        assertDoesNotThrow {
            alice.setupAccount()
            val id = alice.mint(metadata, royalties)
            alice.sellItem(id, 0.50)
            val buyId = alice.readStorefrontIds()!!.first()
            alice.removeItem(buyId)
        }
    }
}

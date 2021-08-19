import org.junit.jupiter.api.Assertions.assertEquals
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.assertDoesNotThrow
import org.junit.jupiter.api.assertThrows
import util.Contracts
import kotlin.test.Ignore
import kotlin.test.assertTrue

internal class ContractsTest {

    private val deployedContracts = mapOf(
        "FungibleToken" to "0xee82856bf20e2aa6",
        "FlowToken" to "0x0ae53cb6e3f42a79"
    )
    private val deployList = mapOf(
        "0xf8d6e0586b0a20c7" to listOf(
            "NFTPlus",
            "CommonNFT",
            "FtPathMapper",
            "AssetBound",
            "NonFungibleToken",
            "RegularSaleOrder",
            "SaleOrder",
            "MarketFee",
        )
    ).flatMap { (address, contracts) -> contracts.map { it to address } }.toMap()
    private val contracts = Contracts("cadence", "contracts", deployedContracts, deployList)


    @Test
    fun contractTextRaw() {
        assertDoesNotThrow { contracts.contractText("NonFungibleToken") }
    }

    @Test
    fun contractText() {
        assertDoesNotThrow { contracts.contractText("NonFungibleToken") }
    }

    @Test
    fun contractSource() {
        assertEquals(contracts.contractSource("Name"), "contracts/Name.cdc")
    }

    @Test
    fun contractAlias() {
        assertEquals(contracts.contractAlias("Name"), "0xNAME")
    }

    @Test
    fun replaceImports() {
        val script = """
            import FungibleToken from 0xFUNGIBLETOKEN 
            import FlowToken from 0xFLOWTOKEN
        """.trimIndent()
        val result = """
            import FungibleToken from 0xee82856bf20e2aa6 
            import FlowToken from 0x0ae53cb6e3f42a79
        """.trimIndent()
        val invalidScript = """
            import NonExistent from 0xNONEXISTENT 
        """.trimIndent()
        assertEquals(contracts.replaceImports(script), result)
        val exception = assertThrows<IllegalStateException> {
            contracts.replaceImports(invalidScript)
        }
        assertEquals(exception.message, "Not found address for alias: 0xNONEXISTENT")
    }

    @Test
    fun calculateDependencies() {
        val expect = listOf(
            "NFTPlus" to setOf("NonFungibleToken"),
            "CommonNFT" to setOf("NonFungibleToken", "NFTPlus"),
            "FtPathMapper" to setOf(),
            "AssetBound" to setOf("SaleOrder"),
            "NonFungibleToken" to setOf(),
            "RegularSaleOrder" to setOf("NonFungibleToken",
                "SaleOrder",
                "MarketFee",
                "AssetBound",
                "NFTPlus",
                "CommonNFT",
                "FtPathMapper"),
            "SaleOrder" to setOf(),
            "MarketFee" to setOf("NonFungibleToken")
        )
        val result = contracts.calculateDependencies(
            contracts.deployAddresses.keys.toList(),
            contracts.deployedAddresses.keys.toList()
        )
        assertTrue { result.toTypedArray().contentDeepEquals(expect.toTypedArray()) }
    }

    @Test
    fun resolveDeployOrder() {
        val expect = listOf(
            "FtPathMapper",
            "NonFungibleToken",
            "SaleOrder",
            "NFTPlus",
            "AssetBound",
            "MarketFee",
            "CommonNFT",
            "RegularSaleOrder"
        )
        val deps = contracts.calculateDependencies(
            contracts.deployAddresses.keys.toList(),
            contracts.deployedAddresses.keys.toList()
        )
        assertTrue { contracts.resolveDeployOrder(deps) == expect }
    }
}

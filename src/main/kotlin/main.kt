import Config.*

val config = Config(
    connect = Connect("localhost", 3569),
    accounts = listOf(
        Account(
            "service",
            "f8d6e0586b0a20c7",
            "ba412c8efe86d806da91ad655bf2c6bcf8fa1c8f8a2bb5cdd0de43fcaab1a2f9",
            "ed0d199902395428026e5055bfeaa7e823c5e1da978b3088dc6ef11ee74f4503526db91baca581dd0de140a0cab8a6234b01e9b5849dd941b556999f3c1eed16"
        ),
        Account("alice"),
    ),
    contracts = listOf(
        Contract("FlowToken", "0xFLOWTOKEN", "contracts/FlowToken.cdc", "0x0ae53cb6e3f42a79"),
        Contract("FungibleToken", "0xFUNGIBLETOKEN", "contracts/FungibleToken.cdc", "0xee82856bf20e2aa6"),
        Contract("AssetBound", "0xASSETBOUND", "contracts/AssetBound.cdc"),
        Contract("BidOrder", "0xBIDORDER", "contracts/BidOrder.cdc"),
        Contract("FtPathMapper", "0xFTPATHMAPPER", "contracts/FtPathMapper.cdc"),
        Contract("MarketFee", "0xMARKETFEE", "contracts/MarketFee.cdc"),
        Contract("NFTProvider", "0xNFTPROVIDER", "contracts/NFTProvider.cdc"),
        Contract("NonFungibleToken", "0xNONFUNGIBLETOKEN", "contracts/NonFungibleToken.cdc"),
        Contract("RegularSaleOrder", "0xREGULARSALEORDER", "contracts/RegularSaleOrder.cdc"),
        Contract("SaleOrder", "0xSALEORDER", "contracts/SaleOrder.cdc"),
        Contract("StoreShowCase", "0xSTORESHOWCASE", "contracts/StoreShowCase.cdc"),
    ),
    scheme = mapOf(
        "service" to listOf(
            "NonFungibleToken",
            "AssetBound",
            "BidOrder",
            "FtPathMapper",
            "FungibleToken",
            "MarketFee",
            "NFTProvider",
            "RegularSaleOrder",
            "SaleOrder",
            "StoreShowCase",
        )
    ),
    "cadence"
)

fun main() {
    val context = Context(config)
//    println(config.aliasAddressMapping)
//    println(context.aliasAddressMapping)
//    println(config.resolveContractOrder())
    println(config.resolveContractOrderEx())
//    println(context.deployContract(context.serviceAccount, config.contractAliases["NonFungibleToken"]!!))

    for ((accountName, contractName) in config.resolveContractOrderEx()) {
        val account = context.accountAliases[accountName]!!
        val contract = config.contractAliases[contractName]!!
        println("deploy: ${contract.name} to ${account.address.formatted}")
        context.deployContract(account, contract)
    }
}

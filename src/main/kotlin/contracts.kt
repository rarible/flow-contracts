fun main() {
    val deployedContracts = mapOf(
        "FungibleToken" to "0xee82856bf20e2aa6",
        "FlowToken" to "0x0ae53cb6e3f42a79"
    )
    val deployList = mapOf(
        "0xf8d6e0586b0a20c7" to listOf(
            "NFTProvider",
            "AssetBound",
            "NonFungibleToken",
            "RegularSaleOrder",
            "SaleOrder",
            "MarketFee",
        )
    ).flatMap { (address, contracts) -> contracts.map { it to address } }.toMap()

    // sed file for replace aliases to paths in contracts
//    with(File("cadence/alias_to_path.sed")) { writeText(c.joinToString("\n") { "s/${it.alias}/\"${it.name}.cdc\"" } + "\n") }

    val c = Contracts("cadence", "contracts", deployedContracts, deployList)

//    val dependencies = Contracts.calculateDependencies(deployList.keys.toList(), deployedContracts.keys.toList())
//    val ordered = Contracts.resolveDeployOrder(dependencies)
    println(c.ordered)
}

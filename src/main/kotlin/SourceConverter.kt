class SourceConverter(contractNameToAddress: Map<String, String>) {
    companion object {
        private val importRe = Regex("0x\\w+")
    }

    private fun contractAlias(name: String) = "0x${name.uppercase()}"

    private val aliasMapping = contractNameToAddress
        .map { (name, address) -> contractAlias(name) to address }
        .toMap()

    fun replaceImports(script: String): String =
        importRe.replace(script) {
            aliasMapping[it.value]
                ?: aliasMapping[it.value.substring(0, it.value.length - 7)]
                ?: throw IllegalStateException("Not found address for alias: ${it.value}")
        }
}

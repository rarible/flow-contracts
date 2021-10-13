import java.io.File

private val File.isCadenceFile: Boolean
    get() = isFile && extension == "cdc"

private val importRegex = Regex("""import (\w+) from.*""")

private fun fixImports(source: File, contractMap: Map<String, File>) = source.readText().replace(importRegex) {
    val contractName = it.groupValues[1]
    val contract = contractMap[contractName]
        ?: throw IllegalStateException("Warning: Not found contracts in map: $contractName")
    val importPath = contract.toRelativeString(source.parentFile)

    "import $contractName from \"${importPath}\""
}

fun main() {
    val cadenceRoot = File("cadence")

    val contractsMap = File(cadenceRoot, "contracts").walk()
        .filter { it.isCadenceFile }
        .associateBy { it.nameWithoutExtension }

    cadenceRoot.walk().filter { it.isCadenceFile }.forEach { current ->
        with(current) {
            writeText(fixImports(current, contractsMap))
        }
    }
}

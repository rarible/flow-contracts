import java.io.File

class Contracts(
    private val cadenceRoot: String,
    private val contractsPath: String,
    val deployedAddresses: Map<String, String>,
    val deployAddresses: Map<String, String>,
) {
    companion object {
        private val importRe = Regex("0x\\w+")
    }

    data class Contract(
        val name: String,
        val address: String,
        val source: String,
    )

    fun contractsForDeploy() = ordered.map {
        Contract(
            name = it,
            address = deployAddresses[it]!!,
            source = contractText(it)
        )
    }

    private val dependencies: List<Pair<String, Set<String>>> =
        calculateDependencies(deployAddresses.keys.toList(), deployedAddresses.keys.toList())

    val ordered: List<String> =
        resolveDeployOrder(dependencies)

    val aliasMapping = (deployedAddresses + deployAddresses)
        .map { (name, address) -> contractAlias(name) to address }
        .toMap()

    private fun contractTextRaw(name: String) = File("${cadenceRoot}/${contractSource(name)}").readText()

    fun contractText(name: String) = replaceImports(contractTextRaw(name))

    operator fun get(name: String) = contractText(name)

    fun contractSource(name: String) = "${contractsPath}/$name.cdc"

    fun contractAlias(name: String) = "0x${name.uppercase()}"

    fun replaceImports(script: String): String =
        importRe.replace(script) {
            aliasMapping[it.value] ?: throw IllegalStateException("Not found address for alias: ${it.value}")
        }

    /**
     * Вычисление зависимостей для каждого контракта из [deployList]
     *
     * @param deployList список имен контрактов для деплоя
     * @param deployed список имен уже установленных контрактов
     */
    fun calculateDependencies(deployList: List<String>, deployed: List<String>): List<Pair<String, Set<String>>> {
        val deployedMap = deployed.associateBy { contractAlias(it) }
        val contractMapping = deployList.associateBy { contractAlias(it) }
        return deployList.map { name ->
            name to importRe.findAll(contractTextRaw(name))
                .map(MatchResult::value)
                .mapNotNull {
                    contractMapping[it]
                        ?: if (deployedMap.containsKey(it)) null
                        else throw IllegalStateException("Not found contract definition for $it")
                }
                .toSet()
        }
    }

    /**
     * Определение порядка деплоя контрактов исходя из зависимостей
     *
     * @param contractsWithDeps список пар: имя контракта для деплоя, список имен контрактов от которых он зависит
     * @return список имен контрактов в порядке для деплоя
     */
    fun resolveDeployOrder(contractsWithDeps: List<Pair<String, Set<String>>>): List<String> {
        tailrec fun helper(deps: List<Pair<String, Set<String>>>, resolved: List<String>): List<String> {
            val (part, rest) = deps.partition { resolved.containsAll(it.second) }
            return when {
                part.isEmpty() -> throw IllegalStateException("Order calculation error, resolved: ${part.joinToString { it.first }}, unresolved: ${rest.joinToString { it.first }}")
                rest.isEmpty() -> resolved + part.map { it.first }
                else -> helper(rest, resolved + part.map { it.first })
            }
        }
        return helper(contractsWithDeps, emptyList())
    }

    fun saveSedConfig() {
        with(File("$cadenceRoot/contracts.sed")) {
            writeText(
                (deployedAddresses.keys + ordered)
                    .joinToString("\n") { "s/${contractAlias(it)}/\"$it.cdc\"/g" } + "\n"
            )
        }
        with(File("$cadenceRoot/scripts.sed")) {
            writeText(
                (deployedAddresses.keys + ordered)
                    .joinToString("\n") { "s/${contractAlias(it)}/\"..\\/..\\/contracts\\/$it.cdc\"/g" } + "\n"
            )
        }
    }
}
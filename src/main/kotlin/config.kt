import java.io.File

data class Config(
    val connect: Connect,
    val accounts: List<Account>,
    val contracts: List<Contract>,
    val scheme: Map<String, List<String>>,
    val projectPath: String,
) {

    data class Connect(
        val host: String,
        val port: Int,
        val serviceAccountName: String = "service"
    )

    data class Contract(
        val name: String,
        val alias: String,
        val source: String,
        val address: String? = null,
    )

    data class Account(
        val name: String,
        val address: String? = null,
        val privateKey: String? = null,
        val publicKey: String? = null,
    )

    val contractAliases = contracts.associateBy(Contract::name)

    val aliasAddressMapping =
        contracts.filter { it.address != null }.associate { it.alias to it.address!! }

    val contractDepsRe = Regex("0x\\w+")

    fun fromResource(name: String) =
        javaClass.classLoader.getResourceAsStream(name)!!
            .use { it.bufferedReader().readText() }

    fun fromProjectRaw(name: String) =
        File(projectPath, name).readText()

    fun getContractDeps(contract: Contract) =
        contractDepsRe.findAll(fromProjectRaw(contract.source))
            .map { it.value }
            .map { alias ->
                val c =
                    contracts.find { it.alias == alias }
                        ?: throw IllegalStateException("Not found contract by alias: $alias")
                c.name
            }
            .toSet()
//            .also(::println)

    fun resolveContractOrder(): List<String> {
        val depsMapping = contracts.filter { it.address == null }.associate { it.name to getContractDeps(it) }
        val contractToDeploy = scheme.values.flatten()

        tailrec fun helper(src: List<String>, dest: List<String> = emptyList()): List<String> {
            if (src.isEmpty()) return dest
            val r = src.groupBy { dest.containsAll(depsMapping[it].orEmpty()) }
            if (r[true].isNullOrEmpty()) throw IllegalStateException("resolve failed")
            return helper(r[false].orEmpty(), dest + r[true].orEmpty())
        }

        return helper(contractToDeploy)
    }

    fun resolveContractOrderEx(): List<Pair<String, String>> {
        val depsMapping = contracts.filter { it.address == null }.associate { it.name to getContractDeps(it) }
        val contractToDeploy = scheme.flatMap { (address, contracts) -> contracts.map { address to it } }
//        val deployed = contracts.filter { it.address != null }.map { it.name to it.alias }

        tailrec fun helper(
            src: List<Pair<String, String>>,
            dest: List<Pair<String, String>> = emptyList()
        ): List<Pair<String, String>> {
            if (src.isEmpty()) return dest
            val r = src.groupBy { (_, c) ->
                dest.map { it.second }.containsAll(depsMapping[c].orEmpty())
            }
            if (r[true].isNullOrEmpty())
                throw IllegalStateException("resolve failed")
            return helper(r[false].orEmpty(), dest + r[true].orEmpty())
        }

        return helper(contractToDeploy)
    }
}

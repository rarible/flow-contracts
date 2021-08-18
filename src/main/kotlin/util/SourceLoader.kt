package util

import java.io.File

object SourceLoader {
    private const val cadenceRoot = "cadence"
    private const val contractsPath = "contracts"
    private const val transactionsPath = "transactions"
    private const val scriptsPath = "scripts"

    private fun fromFile(path: String, name: String) =
        File("$cadenceRoot/$path/$name.cdc").readText()

    fun fromResource(name: String) =
        javaClass.classLoader.getResourceAsStream(name)!!
            .use { it.bufferedReader().readText() }

    fun contract(name: String) = fromFile(contractsPath, name)
    fun transaction(name: String) = fromFile(transactionsPath, name)
    fun script(name: String) = fromFile(scriptsPath, name)
}

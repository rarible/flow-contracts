import java.io.File
import java.util.*

private val importRegex = Regex("""import (\w+) from.*""")

private fun String.toCamelCase() = split("-").joinToString("") { name ->
    name.replaceFirstChar {
        if (it.isLowerCase()) it.titlecase(Locale.getDefault()) else it.toString()
    }
}

private fun aliasedImports(source: String) = source.replace(importRegex) {
    "import ${it.groupValues[1]} from 0x${it.groupValues[1].uppercase()}"
}

private fun fileToJs(file: File) =
    makeJsElement(file.nameWithoutExtension, aliasedImports(file.readText()))

private fun makeJsElement(name: String, source: String) =
    "\t$name: `\n${source.trim()}\n`,\n"

fun makeJsModule(moduleName: String, fileList: List<File>) =
    "export const $moduleName = {\n${fileList.joinToString("", transform = ::fileToJs)}\n}\n".trim()

fun product(vararg items: List<String>) =
    listOf(*items).fold(listOf(listOf<String>())) { acc, value ->
        acc.flatMap { list -> value.map { element -> list + element } }
    }

fun main() {
    val storefrontRoot = File("cadence/transactions/storefront")
    val modules = listOf("common-nft", "motogp-card", "evolution", "topshot")

    // common storefront module
    with(File("build", "storefront-common.ts")) {
        writeText(makeJsModule("StorefrontCommon", listOf(
            File(storefrontRoot, "scripts/read_listing_details.cdc"),
            File(storefrontRoot, "scripts/read_storefront_ids.cdc"),
            File(storefrontRoot, "remove_item.cdc"),
            File(storefrontRoot, "setup_account.cdc"),
        )))
    }

    // nft dependent storefront modules
    val storefrontNftModules = product(modules, listOf("sell", "buy"), listOf("flow", "fusd"))
        .map { (module, operation, currency) -> module to "$module/${operation}_${currency}.cdc" }
        .map { (module, fileName) -> module to File(storefrontRoot, fileName) }
    val storefrontNftScripts = product(modules, listOf("borrow_nft", "check", "get_ids"))
        .map { (module, scriptName) -> module to "$module/scripts/$scriptName.cdc" }
        .map { (module, fileName) -> module to File(storefrontRoot, fileName) }
    (storefrontNftScripts + storefrontNftModules)
        .groupBy(Pair<String, File>::first, Pair<String, File>::second)
        .map { (moduleName, files) -> moduleName to makeJsModule("Storefront${moduleName.toCamelCase()}", files) }
        .forEach { (moduleName, source) ->
            with(File("build", "storefront-$moduleName.ts")) {
                writeText(source)
            }
        }

    // CommonNFT module
    val commonNftRoot = File("cadence/transactions/common-nft")
    with(File("build", "common-nft-sources.ts")) {
        writeText(makeJsModule("CommonNftSources", listOf(
            File(commonNftRoot, "scripts/borrow_nft.cdc"),
            File(commonNftRoot, "scripts/check.cdc"),
            File(commonNftRoot, "scripts/get_ids.cdc"),
            File(commonNftRoot, "setup_account.cdc"),
            File(commonNftRoot, "mint.cdc"),
            File(commonNftRoot, "burn.cdc"),
            File(commonNftRoot, "transfer.cdc"),
        )))
    }
}
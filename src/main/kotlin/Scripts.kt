import org.onflow.sdk.FlowAccessApi
import org.onflow.sdk.ScriptBuilder
import org.onflow.sdk.simpleFlowScript
import java.io.File

class Scripts(val api: FlowAccessApi, val cadenceRoot: String, val aliasMapping: Map<String, String>) {
    companion object {
        private val importRe = Regex("0x\\w+")
    }

    fun scriptTextRaw(name: String) = File("${cadenceRoot}/scripts/${name}").readText()
    fun scriptText(name: String) = replaceImports(scriptTextRaw(name))
    fun replaceImports(script: String): String =
        importRe.replace(script) {
            aliasMapping[it.value] ?: throw IllegalStateException("Not found address for alias: ${it.value}")
        }

    //    fun arguments(arguments: JsonCadenceBuilder.() -> Iterable<Field<*>>) {
//        val builder = JsonCadenceBuilder()
//        this.arguments = arguments(builder).toMutableList()
//    }
//    fun runScript(name: String, args: JsonCadenceBuilder.() -> Iterable<Field<*>>) = api.simpleFlowScript {
    fun runScript(name: String, args: ScriptBuilder.() -> Unit) = api.simpleFlowScript {
        script(scriptText(name))
        arguments.addAll(ScriptBuilder().apply(args).arguments)
    }

    fun checkHolder(address: String) = runScript("nftProvider/check_holder.cdc") {
        arg { address(address) }
    }.jsonCadence.value as Boolean

    fun getNftIds(address: String) = runScript("nftProvider/get_nft_ids.cdc") {
        arg { address(address) }
    }
//        .jsonCadence.value

    fun nftDetails(id: ULong, address: String) = runScript("nftProvider/nft_detail.cdc") {
        arg { uint64(id) }
        arg { address(address) }
    }
}

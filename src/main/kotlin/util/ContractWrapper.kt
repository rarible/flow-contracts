package util

import org.onflow.sdk.FlowAccessApi
import org.onflow.sdk.FlowArgumentsBuilder
import org.onflow.sdk.ScriptBuilder

interface ContractWrapper {
    val api: FlowAccessApi
    val converter: SourceConverter
    val prefix: String
        get() = ""

    fun tx(account: Account, name: String, block: FlowArgumentsBuilder.() -> Unit = {}) =
        api.tx(account, converter.replaceImports(SourceLoader.transaction("$prefix/$name")), block)
            .traceTxResult("util.tx:$prefix/$name.cdc")

    fun sc(name: String, vararg args: Any?, block: ScriptBuilder.() -> Unit) =
        api.sc(converter.replaceImports(SourceLoader.script("$prefix/$name")), block)
            .traceScResult("util.sc:$prefix/$name.cdc", *args)

    fun rtx(account: Account, name: String, block: FlowArgumentsBuilder.() -> Unit = {}) =
        api.tx(account, converter.replaceImports(SourceLoader.fromResource("$prefix/$name.cdc")), block)
            .traceTxResult("rtx:$prefix/$name.cdc")

    fun rsc(name: String, block: ScriptBuilder.() -> Unit) =
        api.sc(converter.replaceImports(SourceLoader.fromResource("$prefix/$name.cdc")), block)
            .traceScResult("rtx:$prefix/$name.cdc")
}

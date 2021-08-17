package util

import Context
import com.nftco.flow.sdk.FlowArgumentsBuilder
import com.nftco.flow.sdk.ScriptBuilder

interface ContractWrapper {
    val context: Context
    val converter: SourceConverter
    val prefix: String
        get() = ""

    fun tx(account: Account, name: String, block: FlowArgumentsBuilder.() -> Unit = {}) =
        context.api.tx(account, converter.replaceImports(SourceLoader.transaction("$prefix/$name")), block)
            .traceTxResult("tx:$prefix/$name.cdc")

    fun sc(name: String, vararg args: Any?, block: ScriptBuilder.() -> Unit = {}) =
        context.api.sc(converter.replaceImports(SourceLoader.script("$prefix/$name")), block)
            .traceScResult("sc:$prefix/$name.cdc", *args)

    fun rtx(account: Account, name: String, block: FlowArgumentsBuilder.() -> Unit = {}) =
        context.api.tx(account, converter.replaceImports(SourceLoader.fromResource("$prefix/$name.cdc")), block)
            .traceTxResult("rtx:$prefix/$name.cdc")

    fun rsc(name: String, block: ScriptBuilder.() -> Unit = {}) =
        context.api.sc(converter.replaceImports(SourceLoader.fromResource("$prefix/$name.cdc")), block)
            .traceScResult("rtx:$prefix/$name.cdc")
}

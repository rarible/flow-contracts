package util

import org.onflow.sdk.*
import org.onflow.sdk.cadence.*
import org.onflow.sdk.crypto.Crypto

fun FlowAccessApi.sc(source: String, args: ScriptBuilder.() -> Unit) = simpleFlowScript {
    script(source)
    arguments.addAll(ScriptBuilder().apply(args).arguments)
}

fun FlowAccessApi.tx(account: Account, source: String, block: FlowArgumentsBuilder.() -> Unit = {}) =
    simpleFlowTransaction(account.address, signer(account), gasLimit = 400L) {
        script(source)
        arguments.addAll(FlowArgumentsBuilder().apply(block).build())
    }.sendAndGetResult(timeoutMs = 100_000L)

fun Pair<FlowId, FlowTransactionResult>.traceTxResult(name: String) = apply {
    println("$name  txID=${first.base16Value}  status=${second.status} (code=${second.statusCode})")
    if (second.errorMessage.isNotBlank()) println(" message=${second.errorMessage}")
    println(" Events: ${second.events.count()}")
    if (second.events.isNotEmpty()) {
        for (event in second.events) {
            println((" [${event.eventIndex}] ${event.id}"))
            for (field in (event.payload.jsonCadence.value as CompositeValue).fields) {
                println("    ${field.name}: ${traceValue(field.value).let { (t, v) -> "$t = $v" }}")
            }
        }
    }
    println()
}

fun FlowScriptResponse.traceScResult(name: String, vararg args: Any?) = apply {
    println("$name (${args.joinToString()})")
    val (type, value) = traceValue(jsonCadence)
    println("  result: $type = $value")
    println()
}

private fun signer(account: Account) = Crypto.getSigner(account.keyPair.private)

private fun traceValue(value: Field<*>): Pair<String, String> = when (value.type) {
    "Array" -> {
        val v = (value as ArrayField).value?.joinToString(", ", "[", "]") {
            traceValue(it).let { (_, v) -> v }
        } ?: "[]"
        "Array" to v
    }
    "Optional" -> {
        val (t, v) = (value as OptionalField).value?.let(::traceValue) ?: "Optional" to "nil"
        "$t?" to v
    }
    "Resource" -> {
        val (t, fields) = (value.value as CompositeValue).let { it.id to it.fields }
        val v = fields.joinToString(", ", "{", "}") {
            "${it.name}: ${traceValue(it.value).let { "${it.first} = ${it.second}" }}"
        }
        t to v
    }
    else -> value.type to value.value.toString()
}

fun FlowScriptResponse.asULongArray() = (jsonCadence.value as ArrayField).value
        ?.filterIsInstance<UInt64NumberField>()
        ?.map { it.toULong()!! }

fun FlowScriptResponse.asBoolean() = jsonCadence.value as Boolean

fun Pair<FlowId, FlowTransactionResult>.uLongValue(event: String, field: String) =
    (findField(event, field) as UInt64NumberField).toULong()

fun Pair<FlowId, FlowTransactionResult>.addressValue(event: String, field: String) =
    (findField(event, field) as AddressField).value

private fun Pair<FlowId, FlowTransactionResult>.findField(event: String, field: String) =
    second[event]?.get<Field<*>>(field)

operator fun FlowTransactionResult.get(postfix: String) =
    events.find { it.type.endsWith(postfix) }

fun ArrayField.toRoyalties() = value
    ?.filterIsInstance<StructField>()
    ?.associate {
        it.get<AddressField>("address")?.value!! to it.get<UFix64NumberField>("fee")?.toDouble()!!
    }

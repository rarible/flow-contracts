package util

import com.nftco.flow.sdk.*
import com.nftco.flow.sdk.cadence.*
import com.nftco.flow.sdk.crypto.Crypto

fun FlowAccessApi.sc(source: String, args: ScriptBuilder.() -> Unit) = simpleFlowScript {
    script(source)
    arguments.addAll(ScriptBuilder().apply(args).arguments)
}

fun FlowAccessApi.tx(account: Account, source: String, block: FlowArgumentsBuilder.() -> Unit = {}) =
    simpleFlowTransaction(account.address, signer(account), gasLimit = 400L) {
        script(source)
        arguments.addAll(FlowArgumentsBuilder().apply(block).build())
    }.sendAndGetResult(timeoutMs = 100_000L)

val reg1 = Regex.fromLiteral("\"type\":\"Type\"")
val reg2 = Regex("""\{"staticType":"([^"]+)"\}""")

// replace "Type" field to "String" field
fun ByteArray.fix(): ByteArray {
    val s1 = reg1.replace(String(this), "\"type\":\"String\"")
    val s2 = reg2.replace(s1) { "\"${it.groupValues[1]}\"" }
    return s2.toByteArray()
}

fun Pair<FlowId, FlowTransactionResult>.traceTxResult(name: String) = apply {
    println("$name  txID=${first.base16Value}  status=${second.status} (code=${second.statusCode})")
    if (second.errorMessage.isNotBlank()) println(" message=${second.errorMessage}")
    println(" Events: ${second.events.count()}")
    if (second.events.isNotEmpty()) {
        for (e in second.events) {
            // FIXME: replace "Type" to "String", because "Type" parsing not implemented in sdk
            val payload = FlowEventPayload(e.payload.bytes.fix())
            val event = e.copy(payload = payload)
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
    val bytes1 = bytes.fix()
    val (type, value) = traceValue(Flow.decodeJsonCadence(bytes1))
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

fun FlowScriptResponse.asULongArray() = (jsonCadence as? ArrayField ?: jsonCadence.value as ArrayField).value
    ?.filterIsInstance<UInt64NumberField>()
    ?.map { it.toULong()!! }

fun FlowScriptResponse.asBoolean() = jsonCadence.value as Boolean

fun Pair<FlowId, FlowTransactionResult>.uLongValue(event: String, field: String) =
    (findField(event, field) as UInt64NumberField).toULong()

fun Pair<FlowId, FlowTransactionResult>.addressValue(event: String, field: String) =
    (findField(event, field) as AddressField).value

fun Pair<FlowId, FlowTransactionResult>.findField(event: String, field: String) =
    second[event]?.get<Field<*>>(field)

operator fun FlowTransactionResult.get(postfix: String) =
    events.find { it.type.endsWith(postfix) }

fun ArrayField.toRoyalties() = value
    ?.filterIsInstance<StructField>()
    ?.associate {
        it.get<AddressField>("address")?.value!! to it.get<UFix64NumberField>("fee")?.toDouble()!!
    }

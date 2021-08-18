class EmulatorApp {
    companion object {
        @JvmStatic
        fun main(args: Array<String>) {
            val context = Context(Emulator, listOf("alice", "bob", "eve"))
            context.contracts.saveSedConfig()
            context.deployScheme.deploy()
        }
    }
}

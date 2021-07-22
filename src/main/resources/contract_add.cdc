transaction(name: String, code: [UInt8] ) {
    prepare(signer: AuthAccount) {
        signer.contracts.add(name: name, code: code)
    }
}

transaction(name: String, code: [UInt8]) {
    prepare(signer: AuthAccount) {
        signer.contracts.update__experimental(name: name, code: code)
    }
}

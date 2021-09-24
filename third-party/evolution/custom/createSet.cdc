import Evolution from "../contracts/Evolution.cdc"

// This transaction creates a new item struct
// and stores it in the Evolution smart contract

transaction(name: String, description: String) {
    prepare(acct: AuthAccount) {

        // borrow a reference to the admin resource
        let admin = acct.borrow<&Evolution.Admin>(from: /storage/EvolutionAdmin)
            ?? panic("No admin resource in storage")
        admin.createSet(name: name, description: description)
    }
}

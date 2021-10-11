import Evolution from "../../../contracts/third-party/Evolution.cdc"

// This transaction creates a new item struct
// and stores it in the Evolution smart contract

transaction(title: String, description: String, hash: String) {
    prepare(acct: AuthAccount) {

        // borrow a reference to the admin resource
        let admin = acct.borrow<&Evolution.Admin>(from: /storage/EvolutionAdmin)
            ?? panic("No admin resource in storage")
        admin.createItem(metadata: {"Title":title, "Description":description, "Hash":hash})
    }
}

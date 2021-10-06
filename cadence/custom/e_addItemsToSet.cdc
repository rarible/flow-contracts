import Evolution from "../contracts/Evolution.cdc"

// This transaction creates a new item struct
// and stores it in the Evolution smart contract

transaction(setId: UInt32, itemIds: [UInt32]) {
    prepare(acct: AuthAccount) {
        // borrow a reference to the admin resource
        let admin = acct.borrow<&Evolution.Admin>(from: /storage/EvolutionAdmin)
            ?? panic("No admin resource in storage")

        let set = admin.borrowSet(setId: setId)
        set.addItems(itemIds: itemIds)
    }
}

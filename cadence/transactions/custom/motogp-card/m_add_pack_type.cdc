import MotoGPAdmin from "../../../contracts/third-party/MotoGPAdmin.cdc"

transaction(pt: UInt64) {
    prepare(acct: AuthAccount) {
        let admin = acct.borrow<&MotoGPAdmin.Admin>(from: /storage/motogpAdmin)!
        admin.addPackType(packType: pt, numberOfCards: 10)
    }

    execute {
    }
}

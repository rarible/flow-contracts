import RaribleFee from "../../contracts/RaribleFee.cdc"

transaction (name: String, address: Address) {
    let manager: &RaribleFee.Manager

    prepare (account: AuthAccount) {
        self.manager = account.borrow<&RaribleFee.Manager>(from: RaribleFee.commonFeeManagerStoragePath)
            ?? panic("Could not borrow fee manager")
    }

    execute {
        self.manager.setFeeAddress(name, address: address)
    }
}

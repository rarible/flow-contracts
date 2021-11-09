import RaribleFee from "../../contracts/RaribleFee.cdc"

transaction (sellerFee: UFix64, buyerFee: UFix64) {
    let manager: &RaribleFee.Manager

    prepare (account: AuthAccount) {
        self.manager = account.borrow<&RaribleFee.Manager>(from: RaribleFee.commonFeeManagerStoragePath)
            ?? panic("Could not borrow fee manager")
    }

    execute {
        self.manager.setSellerFee(sellerFee)
        self.manager.setBuyerFee(buyerFee)
    }
}

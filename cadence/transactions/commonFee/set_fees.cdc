import CommonFee from "../../contracts/CommonFee.cdc"

transaction (sellerFee: UFix64, buyerFee: UFix64) {
    let manager: &CommonFee.Manager

    prepare (account: AuthAccount) {
        self.manager = account.borrow<&CommonFee.Manager>(from: CommonFee.commonFeeManagerStoragePath)
            ?? panic("Could not borrow fee manager")
    }

    execute {
        self.manager.setSellerFee(sellerFee)
        self.manager.setBuyerFee(buyerFee)
    }
}

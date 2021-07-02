/**
 * Set market fee values
 * 
 * @param buyerFee [UFix64] buyer fee
 * @param sellerFee [UFix64] seller fee
 */
import MarketFee from "../../contracts/MarketFee.cdc"
import FungibleToken from "../../contracts/FungibleToken.cdc"

transaction (buyerFee: UFix64, sellerFee: UFix64) {
    prepare(account: AuthAccount) {
        let feeManager = account.getCapability<&MarketFee.FeeManager>(MarketFee.marketFeeManagerPrivate).borrow()!
        feeManager.setBuyerFee(fee: buyerFee)
        feeManager.setSellerFee(fee: sellerFee)
    }
}

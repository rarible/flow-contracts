/**
 * Set market fee values
 * 
 * @param buyerFee [UFix64] buyer fee
 * @param sellerFee [UFix64] seller fee
 */
import MarketFee from 0xMARKETFEEADDRESS
import FungibleToken from 0xFUNGIBLETOKENADDRESS

transaction (buyerFee: UFix64, sellerFee: UFix64) {
    prepare(account: AuthAccount) {
        let feeManager = account.getCapability<&MarketFee.FeeManager>(MarketFee.marketFeeManagerPrivate).borrow()!
        feeManager.setBuyerFee(fee: buyerFee)
        feeManager.setSellerFee(fee: sellerFee)
    }
}

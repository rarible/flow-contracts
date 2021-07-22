import FungibleToken from 0xFUNGIBLETOKENADDRESS
import NonFungibleToken from 0xNONFUNGIBLETOKENADDRESS
import FlowToken from 0xFLOWTOKENADDRESS

pub contract MarketFee {

    pub let marketFeeFlowVault: StoragePath
    pub let marketFeeFlowReceiver: PublicPath
    pub let marketFeeFlowBalance: PublicPath
    pub let marketFeeManager: StoragePath
    pub let marketFeeManagerPrivate: PrivatePath

    pub let feeReceiver: Capability<&{FungibleToken.Receiver}>
    pub let feeBalance: Capability<&{FungibleToken.Balance}>

    init() {
        self.marketFeeFlowVault = /storage/marketFeeFlowVault
        self.marketFeeFlowReceiver = /public/marketFeeFlowReceiver
        self.marketFeeFlowBalance = /public/marketFeeFlowBalance
        self.marketFeeManager = /storage/marketFeeManager
        self.marketFeeManagerPrivate = /private/marketFeeManager

        self.account.save(<- FlowToken.createEmptyVault(), to: self.marketFeeFlowVault)
        self.account.link<&{FungibleToken.Receiver}>(self.marketFeeFlowReceiver, target: self.marketFeeFlowVault)
        self.account.link<&{FungibleToken.Balance}>(self.marketFeeFlowBalance, target: self.marketFeeFlowVault)

        self.account.save(<-create FeeManager(), to: self.marketFeeManager)
        self.account.link<&FeeManager>(self.marketFeeManagerPrivate, target: self.marketFeeManager)

        self.feeReceiver = self.account.getCapability<&{FungibleToken.Receiver}>(self.marketFeeFlowReceiver)
        self.feeBalance = self.account.getCapability<&{FungibleToken.Balance}>(self.marketFeeFlowBalance)
    }


    pub struct StandardFee {
        pub let buyerFee: UFix64
        pub let sellerFee: UFix64

        init(buyerFee: UFix64, sellerFee: UFix64) {
            self.buyerFee = buyerFee
            self.sellerFee = sellerFee
        }

        pub fun check(price: UFix64, vault: &FungibleToken.Vault): Bool {
            return vault.balance >= price * (100.0 + self.buyerFee) / 100.0 
        }

        pub fun charge(price: UFix64, vault: &FungibleToken.Vault) {
            assert(self.check(price: price, vault: vault), message: "insufficient funds")
            let feeAmount = price * (self.buyerFee + self.sellerFee) / 100.0
            let feeReceiver = MarketFee.feeReceiver.borrow()!
            feeReceiver.deposit(from: <- vault.withdraw(amount: feeAmount))
        }
    }

    pub resource FeeManager {
        pub var buyerFee: UFix64
        pub var sellerFee: UFix64

        pub fun getBuyerFee(): UFix64 {
            return self.buyerFee
        }

        pub fun setBuyerFee(fee: UFix64) {
            self.buyerFee = fee
        }

        pub fun getSellerFee(): UFix64 {
            return self.sellerFee
        }

        pub fun setSellerFee(fee: UFix64) {
            self.sellerFee = fee
        }

        init() {
            self.buyerFee = 2.5
            self.sellerFee = 2.5
        }
    }

    pub fun getFees(): {String:UFix64} {
        let feeManager = self.account.getCapability<&FeeManager>(self.marketFeeManagerPrivate).borrow()!
        return {
            "buyerFee": feeManager.buyerFee,
            "sellerFee": feeManager.sellerFee
        }
    }

    pub fun createFee(): StandardFee {
        let feeManager = self.account.getCapability<&FeeManager>(self.marketFeeManagerPrivate).borrow()!
        return StandardFee(buyerFee: feeManager.buyerFee, sellerFee: feeManager.sellerFee)
    }

}
 
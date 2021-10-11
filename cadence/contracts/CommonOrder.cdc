import CommonFee from "CommonFee.cdc"
import FungibleToken from "core/FungibleToken.cdc"
import NFTStorefront from "core/NFTStorefront.cdc"
import NonFungibleToken from "core/NonFungibleToken.cdc"

// CommonOrder
//
// Wraps the NFTStorefront.createListting
//
pub contract CommonOrder {

    pub let BUYER_FEE: String
    pub let SELLER_FEE: String
    pub let OTHER: String
    pub let ROYALTY: String
    pub let REWARD: String

    init() {
        // market buyer fee (on top of the price)
        self.BUYER_FEE = "BUYER_FEE"

        // market seller fee
        self.SELLER_FEE = "SELLER_FEE"

        // additional payments
        self.OTHER = "OTHER"

        // royalty
        self.ROYALTY = "ROYALTY"

        // seller reward
        self.REWARD = "REWARD"
    }

    // PaymentPart
    // 
    pub struct PaymentPart {
        // receiver address
        pub let address: Address

        // payment rate
        pub let rate: UFix64

        init(address: Address, rate: UFix64) {
            self.address = address
            self.rate = rate
        }
    }

    // Payment
    // Describes payment in the event OrderAvailable
    // 
    pub struct Payment {
        // type of payment
        pub let type: String

        // receiver address
        pub let address: Address

        // payment rate
        pub let rate: UFix64

        // payment amount
        pub let amount: UFix64

        init(type: String, address: Address, rate: UFix64, amount: UFix64) {
            self.type = type
            self.address = address
            self.rate = rate
            self.amount = amount
        }
    }

    // OrderAvailable
    // Order created and available for purchase
    // 
    pub event OrderAvailable(
        orderAddress: Address,
        orderId: UInt64,
        nftType: Type,
        nftId: UInt64,
        vaultType: Type,
        price: UFix64, // sum of payment parts
        offerPrice: UFix64, // base for calculate rates
        payments: [Payment]
    )

    // addOrder
    // Wrapper for NFTStorefront.createListing
    //
    pub fun addOrder(
        storefront: &NFTStorefront.Storefront,
        nftProvider: Capability<&{NonFungibleToken.Provider,NonFungibleToken.CollectionPublic}>,
        nftType: Type,
        nftId: UInt64,
        vaultPath: PublicPath,
        vaultType: Type,
        price: UFix64,
        extraCuts: [PaymentPart],
        royalties: [PaymentPart]
    ): UInt64 {
        let orderAddress = storefront.owner!.address
        let payments: [Payment] = []
        let saleCuts: [NFTStorefront.SaleCut] = []
        var percentage = 100.0
        var offerPrice = 0.0

        let addPayment = fun (type: String, address: Address, rate: UFix64) {
            let amount = price * rate / 100.0
            let receiver = getAccount(address).getCapability<&{FungibleToken.Receiver}>(vaultPath)
            assert(receiver.borrow() != nil, message: "Missing or mis-typed fungible token receiver")

            payments.append(Payment(type:type, address:address, rate: rate, amount: amount))
            saleCuts.append(NFTStorefront.SaleCut(receiver: receiver, amount: amount))

            offerPrice = offerPrice + amount
            percentage = percentage - (type == CommonOrder.BUYER_FEE ? 0.0 : rate)
        }

        addPayment(CommonOrder.BUYER_FEE, CommonFee.feeAddress(), CommonFee.buyerFee)
        addPayment(CommonOrder.SELLER_FEE, CommonFee.feeAddress(), CommonFee.sellerFee)

        for cut in extraCuts {
            addPayment(CommonOrder.OTHER, cut.address, cut.rate)
        }

        for royalty in royalties {
            addPayment(CommonOrder.ROYALTY, royalty.address, royalty.rate)
        }

        addPayment(CommonOrder.REWARD, orderAddress, percentage)

        let orderId = storefront.createListing(
            nftProviderCapability: nftProvider,
            nftType: nftType,
            nftID: nftId,
            salePaymentVaultType: vaultType,
            saleCuts: saleCuts
        )

        emit OrderAvailable(
            orderAddress: orderAddress,
            orderId: orderId,
            nftType: nftType,
            nftId: nftId,
            vaultType: vaultType,
            price: price,
            offerPrice: price,
            payments: payments
        )

        return orderId
    }
}

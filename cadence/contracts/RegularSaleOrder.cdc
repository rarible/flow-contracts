import FungibleToken from "FungibleToken.cdc"
import NonFungibleToken from "NonFungibleToken.cdc"
import SaleOrder from "SaleOrder.cdc"
import MarketFee from "MarketFee.cdc"
import AssetBound from "AssetBound.cdc"

pub contract RegularSaleOrder : SaleOrder {

    pub event OrderOpened(id: UInt64, askType: String, askId: UInt64, bidType: String, bidAmount: UFix64, buyerFee: UFix64, sellerFee: UFix64)
    pub event OrderClosed(id: UInt64)
    pub event OrderWithdrawn(id: UInt64)

    pub resource Order : SaleOrder.Close, SaleOrder.Withdraw {
        pub var ask: @NonFungibleToken.NFT?
        pub let bid: AssetBound.FtBound
        pub let receiver: Capability<&{FungibleToken.Receiver}>
        pub let fee: MarketFee.StandardFee

        init(
            ask: @NonFungibleToken.NFT, 
            bid: AssetBound.FtBound, 
            receiver: Capability<&{FungibleToken.Receiver}>,
            fee: MarketFee.StandardFee 
        ) {
            let ref = &ask as &NonFungibleToken.NFT
            self.ask <- ask
            self.bid = bid
            self.receiver = receiver
            self.fee = fee

            emit OrderOpened(id: self.uuid, askType: ref.getType().identifier, askId: ref.id, bidType: bid.type.identifier, bidAmount: bid.amount, buyerFee: self.fee.buyerFee, sellerFee: self.fee.sellerFee)
        }
        pub fun isActive(): Bool {
            return true
        }

        pub fun canBeWithdrawn(): Bool {
            return true
        }

        pub fun close(item: @AnyResource): @AnyResource {
            assert(item.isInstance(self.bid.type), message: "Vault type not match")
            let vault <- item as! @FungibleToken.Vault
            assert(self.fee.check(price: self.bid.amount, vault: &vault as &FungibleToken.Vault), message: "Vault check failed")
            self.fee.charge(price: self.bid.amount, vault: &vault as &FungibleToken.Vault)
            let receiver = self.receiver.borrow()!
            receiver.deposit(from: <- vault)

            let token <- self.ask <- nil
            emit OrderClosed(id: self.uuid)
            return <- token
        }

        pub fun withdraw(): @AnyResource {
            let ask <- self.ask <- nil
            emit OrderWithdrawn(id: self.uuid)
            return <- ask
        }

        destroy() {
            destroy self.ask
        }
    }

    pub fun createOrder(ask: @NonFungibleToken.NFT, bid: AssetBound.FtBound, receiver: Capability<&{FungibleToken.Receiver}>): @RegularSaleOrder.Order {
        return <- create Order(ask: <- ask, bid: bid, receiver: receiver, fee: MarketFee.createFee())
    }
}

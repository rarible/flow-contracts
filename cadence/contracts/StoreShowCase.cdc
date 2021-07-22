import SaleOrder from 0xSALEORDERADDRESS

pub contract StoreShowCase {

    pub event OrderAssigned(id: UInt64, to: Address?)

    pub resource interface ShowCasePublic {
        pub fun getIDs(): [UInt64]
        pub fun close(id: UInt64, item: @AnyResource): @AnyResource
        pub fun borrow(id: UInt64): auth &SaleOrder.Order
    }

    pub resource ShowCase : ShowCasePublic {
        pub let orders: @{UInt64:SaleOrder.Order}

        init() {
            self.orders <- {}
        }

        pub fun getIDs(): [UInt64] {
            return self.orders.keys
        }

        pub fun add(order: @SaleOrder.Order) {
            let ref = &order as &SaleOrder.Order
            let dummy <- self.orders[order.uuid] <- order
            assert(dummy == nil, message: "unexpected dublicate uuid!")
            destroy dummy
            emit OrderAssigned(id: ref.uuid, to: ref.owner?.address)
        }

        pub fun borrow(id: UInt64): auth &SaleOrder.Order {
            let order = &self.orders[id] as auth &SaleOrder.Order 
            return order
        }

        pub fun close(id: UInt64, item: @AnyResource): @AnyResource {
            let order <- self.withdraw(id: id)
            let product <- order.close(item: <- item)
            destroy order
            return <- product
        }

        pub fun withdraw(id: UInt64): @SaleOrder.Order {
            let order <- self.orders.remove(key: id) ?? panic("SaleOrder.Order with the specified id not found")
            return <- order
        }

        destroy() {
            destroy self.orders
        }
    }

    pub fun createShowCase(): @ShowCase {
        return <- create ShowCase()
    }

    pub fun installShowCase(account: AuthAccount) {
        account.save(<- self.createShowCase(), to: self.storeShowCaseStoragePath)
        account.link<&{ShowCasePublic}>(self.storeShowCasePublicPath, target: self.storeShowCaseStoragePath)
    }

    pub let storeShowCasePublicPath: PublicPath
    pub let storeShowCaseStoragePath: StoragePath

    init() {
        self.storeShowCasePublicPath = /public/storeShowCasePublicPath
        self.storeShowCaseStoragePath = /storage/storeShowCaseStoragePath
    }
}

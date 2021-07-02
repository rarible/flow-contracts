pub contract interface SaleOrder {

    pub struct interface Bound {
        pub let type: Type
    }

    pub resource interface Close {
        pub fun isActive(): Bool
        pub fun close(item: @AnyResource): @AnyResource
    }

    pub resource interface Withdraw {
        pub fun canBeWithdrawn(): Bool
        pub fun withdraw(): @AnyResource
    }

    pub resource Order : Close, Withdraw {
        pub fun isActive(): Bool
        pub fun canBeWithdrawn(): Bool
        pub fun close(item: @AnyResource): @AnyResource {
            pre {
                self.isActive(): "Only active orders may be closed directly"
            }
        }
        pub fun withdraw(): @AnyResource {
            pre {
                self.canBeWithdrawn(): "Order can not be withdrawn"
            }
        }
    }

}

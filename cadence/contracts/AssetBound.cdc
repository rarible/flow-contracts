import SaleOrder from 0xSALEORDER

pub contract AssetBound {

    pub struct FtBound : SaleOrder.Bound {
        pub let type: Type
        pub let amount: UFix64

        init(type: Type, amount: UFix64) {
            self.type = type
            self.amount = amount
        }
    }

    pub struct NftBound : SaleOrder.Bound {
        pub let type: Type
        pub let id: UInt64

        init(type: Type, id: UInt64) {
            self.type = type
            self.id = id
        }
    }

    pub fun createFtBound(type: Type, amount: UFix64): FtBound {
        return FtBound(type: type, amount: amount)
    }

    pub fun createNftBound(type: Type, id: UInt64): NftBound {
        return NftBound(type: type, id: id)
    }
}

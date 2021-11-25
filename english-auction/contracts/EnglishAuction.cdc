import FungibleToken from "./core/FungibleToken.cdc"
import NonFungibleToken from "./core/NonFungibleToken.cdc"

pub contract EnglishAuction {

    pub let minimalDuration: UFix64
    pub let maximalDuration: UFix64
    pub let reservePrice: UFix64

    // LotAvailable
    // A lot has been created and available for bids
    pub event LotAvailable(
        lotId: UInt64,
        itemType: String,
        itemId: UInt64,
        bidType: String,
        minimumBid: UFix64,
        buyoutPrice: UFix64?,
        increment: UFix64,
        startAt: UFix64,
        finishAt: UFix64
    )

    // LotCompleted
    // The lot has been resolved
    // If the item was sold, then bidder is the address of the winning bid
    // and HammerPrice is the selling price, otherwise both are nil.
    // isCancelled == true when lot was cancelled before auction is finished.
    pub event LotCompleted(
        lotId: UInt64,
        bidder: Address?,
        hammerPrice: UFix64?,
        isCancelled: Bool
    )

    // LotEndTimeChanged
    // The lot finishAt was changed due to soft close or bayout
    pub event LotEndTimeChanged(
        lotId: UInt64,
        finishAt: UFix64
    )

    // LotCleaned
    // The lot resource was removed, all assets are transferred to the owners
    pub event LotCleaned(
        lotId: UInt64
    )

    pub event OpenBid(
        lotId: UInt64,
        bidder: Address,
        amount: UFix64
    )

    pub event CloseBid(
        lotId: UInt64,
        bidder: Address,
        isWinner: Bool
    )

    // Payout
    // A struct representing the payment to be made by the buyer or seller 
    // upon the successful completion of the auction.
    pub struct Payout {
        pub var target: Capability<&{FungibleToken.Receiver}>
        pub var rate: UFix64

        init(
            target: Capability<&{FungibleToken.Receiver}>,
            rate: UFix64
        ) {
            pre {
                0.0 < rate && rate < 1.0: "AU09: payout: rate must be in range (0,1)"
                target.check(): "AU10: payout: capability not available"
            }
            self.target = target
            self.rate = rate
        }
    }

    // Bid
    pub resource Bid {
        pub let reward: Capability<&{NonFungibleToken.CollectionPublic}>
        pub let refund: Capability<&{FungibleToken.Receiver}>
        pub let vault: @[FungibleToken.Vault]
        pub let payouts: [Payout]
        pub let price: UFix64

        init(
            reward: Capability<&{NonFungibleToken.CollectionPublic}>, 
            refund: Capability<&{FungibleToken.Receiver}>,
            vault: @FungibleToken.Vault,
            payouts: [Payout]
        ) {
            pre {
                reward.address == refund.address : "AU13: bid: reward and refund must be linked at the same address"
                reward.check() : "AU12: bid: broken reward capability"
                refund.check() : "AU11: bid: broken refund capability"
            }
            let balance = vault.balance
            self.reward = reward
            self.refund = refund
            self.vault <- [<-vault]
            self.payouts = payouts
            var total: UFix64 = 0.0
            for payout in payouts {
                total = total + payout.rate
            }
            assert(total < 1.0, message: "AU17: bid: the amount of payouts must be in the range [0,1)")
            self.price = balance / (1.0 + total)
        }

        pub fun safeRefund(): Bool {
            pre {
                self.vault.length == 1: "AU18: Bid vault not found"
            }
            let ref = self.refund.borrow()
            if (ref != nil) {
                ref!.deposit(from: <- self.vault.removeFirst())
                return true
            }
            return false
        }

        destroy() {
            assert(self.vault.length == 0, message: "AU19: Destroy non-empty vault")
            destroy self.vault
        }
    }

    pub resource Lot {

        // Seller info
        pub let reward: Capability<&{FungibleToken.Receiver}>
        pub let refund: Capability<&{NonFungibleToken.CollectionPublic}>
        access(self) let item: @[NonFungibleToken.NFT]
        access(self) let payouts: [Payout]

        // Auction params
        pub let bidType: Type
        pub let minimumBid: UFix64
        pub let buyoutPrice: UFix64?
        pub let increment: UFix64
        pub let startAt: UFix64
        pub let duration: UFix64

        // State
        access(self) let bids: @{Address: Bid}
        pub var finishAt: UFix64
        pub var primaryBid: Address?

        init(
            reward: Capability<&{FungibleToken.Receiver}>,
            refund: Capability<&{NonFungibleToken.CollectionPublic}>,
            item: @NonFungibleToken.NFT,
            bidType: Type,
            minimumBid: UFix64,
            buyoutPrice: UFix64?,
            increment: UFix64,
            startAt: UFix64,
            duration: UFix64,
            payouts: [Payout]
        ) {
            pre {
                reward.address == refund.address : "AU23: lot: reward and refund must be linked at the same address"
                reward.check() : "AU22: lot: broken reward capability"
                refund.check() : "AU21: lot: broken refund capability"
            }
            self.reward = reward 
            self.refund = refund
            self.item <- [<-item]
            self.bidType = bidType
            self.minimumBid = minimumBid
            self.buyoutPrice = buyoutPrice
            self.increment = increment
            self.startAt = startAt
            self.duration = duration
            self.payouts = payouts

            self.bids <- {}
            self.finishAt = self.startAt + self.duration
            self.primaryBid = nil

            emit LotAvailable(
                lotId: self.uuid,
                itemType: self.item[0].getType().identifier,
                itemId: self.item[0].id,
                bidType: bidType.identifier,
                minimumBid: self.minimumBid,
                buyoutPrice: self.buyoutPrice,
                increment: self.increment,
                startAt: self.startAt,
                finishAt: self.finishAt
            )
        }

        pub fun refundLot(isCancelled: Bool) {
            pre {
                self.primaryBid == nil: "AU05: Lot have a bid(s), so it can't be cancelled"
                self.refund.check(): "AU21: lot: broken refund capability"
            }
            self.refund.borrow()!.deposit(token: <- self.item.removeFirst())
            emit LotCompleted(lotId: self.uuid, bidder: nil, hammerPrice: nil, isCancelled: isCancelled)
        }
        
        // rewardSeller
        //
        // send money to seller, make all payouts, can be called only when auction is finished
        // returns true if money moved, else false
        pub fun rewardSeller() {
            pre {
                self.primaryBid != nil: "AU06: primary bid not found"
            }
            let bid = &self.bids[self.primaryBid!] as &Bid
            if (bid.vault.length == 1 && self.reward.check()) {
                let vault <- bid.vault.removeFirst()

                // make payouts from bidder
                for payout in bid.payouts {
                    payout.target.borrow()!.deposit(from: <- vault.withdraw(amount: payout.rate * bid.price))
                }

                emit LotCompleted(
                    lotId: self.uuid,
                    bidder: bid.reward.address,
                    hammerPrice: vault.balance,
                    isCancelled: false
                )

                // make payouts from seller
                for payout in self.payouts {
                    payout.target.borrow()!.deposit(from: <- vault.withdraw(amount: payout.rate * bid.price))
                }

                // reward seller
                self.reward.borrow()!.deposit(from: <- vault)
            }
        }

        // rewardBider
        //
        // send item to bidder, can be called only when auction is finished
        // returns true if item moved, else false
        pub fun rewardBidder(): Bool {
            pre {
                self.primaryBid != nil: "AU06: primary bid not found"
            }
            let bid = &self.bids[self.primaryBid!] as &Bid
            if (self.item.length == 1 && bid.reward.check()) {
                emit CloseBid(
                    lotId: self.uuid,
                    bidder: bid.reward.address,
                    isWinner: true
                )
                bid.reward.borrow()!.deposit(token: <- self.item.removeFirst())
                return true
            }
            return false
        }

        // try to refund previous bid, if it doesn't work, don't stop
        // this need to prevent cheating
        pub fun refundBids() {
            for key in self.bids.keys {
                let bid = &self.bids[key] as &Bid
                if (key != self.primaryBid && bid.safeRefund()) {
                    emit CloseBid(
                        lotId: self.uuid,
                        bidder: bid.reward.address,
                        isWinner: false
                    )
                    let dummy <- self.bids.remove(key: key)
                    destroy dummy
                }
            }
        }

        pub fun addBid(bid: @Bid) {
            pre {
                bid.price >= self.minimumBid: "AU15: amount must be greater than minimum bid"
                self.bids[bid.reward.address] == nil: "AU14: bid already exists"
            }

            if (self.primaryBid != nil) {
                let primary = &self.bids[self.primaryBid!] as &Bid
                assert(bid.price >= primary.price + self.increment, message: "AU16: bid is too small")
            }

            emit OpenBid(
                lotId: self.uuid,
                bidder: bid.reward.address,
                amount: bid.price
            )

            self.refundBids()
            self.primaryBid = bid.reward.address
            let dummy <- self.bids[bid.reward.address] <- bid
            destroy dummy
        }

        pub fun setFinishAt(timestamp: UFix64) {
            self.finishAt = timestamp
            emit LotEndTimeChanged(lotId: self.uuid, finishAt: timestamp)
        }

        pub fun isEmpty(): Bool {
            if (self.item.length > 0) {
                return false
            }
            if (self.primaryBid == nil) {
                return self.bids.length == 0
            }
            if (self.bids.length > 1) {
                return false
            }
            let bid = &self.bids[self.primaryBid!] as &Bid
            return bid.vault.length == 0
        }

        destroy() {
            emit LotCleaned(lotId: self.uuid)
            destroy self.bids
            destroy self.item
        }
    }

    pub resource AuctionHouse {
        access(self) let lots: @{UInt64: Lot}

        init() {
            self.lots <- {}
        }

        destroy() {
            destroy self.lots
        }

        pub fun getIDs(): [UInt64] {
            return self.lots.keys
        }

        pub fun borrowLot(lotId: UInt64): &Lot {
            assert(self.lots.keys.contains(lotId), message: "AU08: Lot not found")
            return &self.lots[lotId] as! &Lot
        }

        pub fun addLot(
            reward: Capability<&{FungibleToken.Receiver}>,
            refund: Capability<&{NonFungibleToken.CollectionPublic}>,
            item: @NonFungibleToken.NFT,
            bidType: Type,
            minimumBid: UFix64,
            buyoutPrice: UFix64?,
            increment: UFix64,
            startAt: UFix64?,
            duration: UFix64,
            payouts: [Payout]
        ): UInt64 {
            let timestamp = getCurrentBlock().timestamp
            let lot <- create Lot(
                reward: reward,
                refund: refund,
                item: <- item,
                bidType: bidType,
                minimumBid: minimumBid,
                buyoutPrice: buyoutPrice,
                increment: increment,
                startAt: (startAt ?? 0.0) == 0.0 ? timestamp : startAt!,
                duration: duration,
                payouts: payouts
            )

            let id = lot.uuid
            self.lots[id] <-! lot
            return id
        }

        pub fun cancelLot(auth: AuthAccount, lotId: UInt64) {
            let lot <- self.lots.remove(key: lotId) ?? panic("AU08: lot not found")
            assert(auth.address == lot.reward.address, message: "AU07: Only lot owner can cancel it")
            let timestamp = getCurrentBlock().timestamp
            lot.refundLot(isCancelled: timestamp < lot.finishAt)
            destroy lot
        }

        pub fun completeLot(lotId: UInt64) {
            let lotRef = self.borrowLot(lotId: lotId)
            let timestamp = getCurrentBlock().timestamp
            assert(timestamp >= lotRef.finishAt, message: "AU04: The auction is not finished yet")
            lotRef.rewardBidder()
            lotRef.rewardSeller()
            lotRef.refundBids()
            if (lotRef.isEmpty()) {
                destroy self.lots.remove(key: lotId)
            }
        }

        pub fun addBid(
            lotId: UInt64,
            reward: Capability<&{NonFungibleToken.CollectionPublic}>,
            refund: Capability<&{FungibleToken.Receiver}>,
            vault: @FungibleToken.Vault,
            payouts: [Payout]
        ) {
            let lotRef = self.borrowLot(lotId: lotId)
            let timestamp = getCurrentBlock().timestamp
            assert(timestamp >= lotRef.startAt, message: "AU02: The auction has not started yet")
            assert(timestamp < lotRef.finishAt, message: "AU03: The auction is already finished")

            let bid <- create Bid(
                reward: reward,
                refund: refund,
                vault: <- vault,
                payouts: payouts
            )
            let bidPrice = bid.price
            lotRef.addBid(bid: <- bid)
            // soft close
            // when a bid was placed in the last set amount of minutes,
            // the auction automatically extends a set period of time 
            if (timestamp + EnglishAuction.minimalDuration > lotRef.finishAt) {
                lotRef.setFinishAt(timestamp: timestamp + EnglishAuction.minimalDuration)
            }
            // check buyout price
            if (bidPrice >= (lotRef.buyoutPrice ?? 0.0)) {
                lotRef.setFinishAt(timestamp: timestamp)
                self.completeLot(lotId: lotId)
            }
        }
    }

    pub fun borrowAuction(): &AuctionHouse {
        return self.account
            .getCapability(/public/EnglishAuctionPublic)
            .borrow<&EnglishAuction.AuctionHouse>()
            ?? panic("AU01: Can not borrow auction resource")
    }

    init() {
        // minimal auction duration 1h
        // self.minimalDuration = 3600.0
        self.minimalDuration = 60.0 // 1m for debugging purpose

        // maximal auction duration 60d
        self.maximalDuration = 60.0 * 24.0 * 60.0 * 60.0

        // a minimum acceptable price established by the seller
        self.reservePrice = 0.00001

        let EnglishAuction: @EnglishAuction.AuctionHouse <- create AuctionHouse()
        self.account.save(<-EnglishAuction, to: /storage/EnglishAuctionStorage)
        self.account.link<&EnglishAuction.AuctionHouse>(/public/EnglishAuctionPublic, target: /storage/EnglishAuctionStorage)
    }
}

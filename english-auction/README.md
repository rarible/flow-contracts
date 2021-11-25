# English Auction

English auction, also known as an open ascending price auction. Participants bid openly against one another, with each
subsequent bid required to be higher than the previous bid. The auction ends when no participant is willing to bid
further, at which point the highest bidder pays their bid. Alternatively, if no bids have been made before the end of
the auction, the item remains unsold. The auctioneer sets a minimum amount, sometimes known as a bidding increment, by
which the next bid must exceed the current highest bid.



## Events

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

## Error codes

#### AU01: Can not borrow auction resource

#### AU02: The auction has not started yet

#### AU03: The auction is already finished

#### AU04: The auction is not finished yet

#### AU05: Lot have a bid(s), so it can't be cancelled

#### AU06: primary bid not found

#### AU07: Only lot owner can cancel it

#### AU08: Lot not found

#### AU09: payout: rate must be in range (0,1)

#### AU10: payout: capability not available

#### AU11: bid: broken refund capability

#### AU12: bid: broken reward capability

#### AU13: bid: reward and refund must be linked at the same address

#### AU14: bid already exists

#### AU15: amount must be greater than minimum bid

#### AU16: bid is too small

#### AU17: bid: the amount of payouts must be in the range [0,1)

#### AU18: Bid vault not found

#### AU19: Destroy non-empty vault

#### AU21: lot: broken refund capability

#### AU22: lot: broken reward capability

#### AU23: lot: reward and refund must be linked at the same address

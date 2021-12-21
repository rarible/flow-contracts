# English Auction

English auction, also known as an open ascending price auction. Participants bid openly against one another, with each
subsequent bid required to be higher than the previous bid. The auction ends when no participant is willing to bid
further, at which point the highest bidder pays their bid. Alternatively, if no bids have been made before the end of
the auction, the item remains unsold. The auctioneer sets a minimum amount, sometimes known as a bidding increment, by
which the next bid must exceed the current highest bid.

## Addresses

| Contract | EnglishAuction |
| --- | :---: |
| Testnet address | [`0xebf4ae01d1284af8`](https://flow-view-source.com/testnet/account/0xebf4ae01d1284af8) |
| Testnet block height | [52899327](https://testnet.flowscan.org/transaction/56388da3ad7706ac7ecdd1bb8055d2adde383fc0d794795ec4d8d04ad5cf9b65)|


## Константы

В контракте EnglishAuction заданы некоторые значения, влияющие на все аукционы.

- **minimalDuration** минимальная продолжительность аукциона, 15 минут;
- **maximalDuration** максимальная продолжительность аукциона, 60 дней;
- **reservePrice** минимальная стоимость, все величины имеющие стоимостное выражение (количество FungibleToken), должны
  быть больше этой величины.

## Лоты

Лот - ресурс сохраняемый на аккаунте контракта аукциона, аккумулирующий в себе предметы и кошельки участвующие в торгах,
параметры и состояние аукциона, лот удаляется после завершения аукциона и пересылки активов владельцам. Лот обеспечивает
обязательства продавца реализовать предмет в соответствии с правилами аукциона.

Лот может быть создан любым пользователем. При создании лота, в него вкладывается продаваемый предмет, задается валюта
продажи и параметры лота, такие как:

- **minimumBid** стартовая цена;
- **increment** шаг, минимальный прирост цены;
- **buyoutPrice** цена выкупа, "buy it now", опционально;
- **startAt** время с которого будет начат приём бидов, если не задан, то с текущего блока;
- **duration** продолжительность аукциона.

Если задан **buyoutPrice** то первый лот достигший этой величины, будет объявлен победителем, и аукцион будет завершен.

Продолжительность аукциона может быть изменена в если:

- выкуп предмета по **buyoutPrice**;
- установки бида за время меньшее **minimalDuration** (15m) до окончания аукциона, в этом случае окончание аукциона
  будет задано как время последнего бида + **minimalDuration**.

Лот может быть отменён продавцом в любое время, если не содержит ни одного бида.

## Биды

Бид - обеспечивает обязательства покупателя приобрести предмет за указанную цену в случае выигрыша. Бид содержит
кошелек заданной валюты обеспечавающий выплату комиссий с покупателя и вознаграждения продавцу.

Бид может быть добавлен любым пользователем к любому активному лоту. В бид должен быть вложена сумма в валюте лота, как
минимум равная сумме предыдущего бида + **increment** + комиссии покупателя.

Бид отменяется автоматически при добавлении нового бида. Если по каким-то причинам вернуть актив бида не удалось,
он остается в лоте до востребования, но в логике работы аукциона не участвует.

## Выплаты

Лоты и биды содержат:
- актив (предмет или деньги); 
- ссылки **reward** и **refund**, для получения вознаграждения или возврата активов; 
- список комиссий (взымаемых соответственно с продавца или покупателя) в виде `{адрес:доля}`.

При успешном завершении аукциона, предмент переходит к новому владельцу, выплачиваются все комиссии, и остаток средств
зачисляется на счёт продавца.

При отмене лота или бида, актив возвращается владельцу без выплаты комиссий.

## Завершение аукциона

Аукцион считается завершенным начиная с блока, timestamp которого не меньше заданного в лоте **finishAt**.

Если на этот момент нет ни одного бида, единственное что можно сделать с лотом - отменить.

Если на момент завершения аукциона есть хоть один бид, аукцион считается успешным, но для выполнения всех выплат
необходимо инициировать завершение аукциона.
Инициировать завершение аукциона может любой пользователь, например: продавец, покупатель или сервисный аккаунт.
Инициатор завершения аукциона не влияет на производимые действия, только оплачивает транзакцию.

После успешной пересылки всех активов, ресурс аукциона удаляется.

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

#### AU05: Lot has a bid(s), so it can't be cancelled

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

#### AU20: Primary bid not found

#### AU21: lot: broken refund capability

#### AU22: lot: broken reward capability

#### AU23: lot: reward and refund must be linked at the same address

# MarketFee

Контракт содержит ресурс `FeeManager` для управления коммиссиями маркетплейса, кошельки для всех поддерживаемых валют (для зачисления комиссий). По-умолчанию установлены `buyerFee` и `sellerFee` по 2.5%.


## Транзакции

### [`set_market_fee.cdc`][set_market_fee]

Параметры:
- *buyerFee:UFix64* комиссия покупателя
- *sellerFee:UFix64* комиссия продавца

Устанавливает новые комиссии маркетплейса.

## Скрипты

### [`get_flow_amount.cdc`][get_flow_amount]

Без параметров. Возвращает сумму комиссий на кошельке `FLOW`

### [`get_market_fee.cdc`][get_market_fee]

Без параметров. Возвращает коллекцию со ставками комиссий в процентах.
Пример:

        {"buyerFee": 2.50000000, "sellerFee": 2.50000000}


[set_market_fee]: <https://github.com/rariblecom/flow-contracts/blob/main/cadence/transactions/marketFee/set_market_fee.cdc>
[get_flow_amount]: <https://github.com/rariblecom/flow-contracts/blob/main/cadence/scripts/marketFee/get_flow_amount.cdc>
[get_market_fee]: <https://github.com/rariblecom/flow-contracts/blob/main/cadence/scripts/marketFee/get_market_fee.cdc>

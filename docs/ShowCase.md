# StoreShowCase

Обеспечивает листинг ордеров пользователя. Должна быть произведена инициализация на аккаунте пользователя.

## Транзакции

### [`init_show_case.cdc`][init_show_case]

Инициализация аккаунта подписанта. Без параметров.

### [`regular_sale_create.cdc`][regular_sale_create]

Создание ордера на продажу NFT за Flow токены, на аккаунте подписанта.

Параметры:
- *tokenId:UInt64* - идентификатор NFT из коллекции пользователя
- *amount:UFix64* - цена во Flow

### [`regular_sale_purchase.cdc`][regular_sale_purchase]

Покупка NFT за Flow токены.

Параметры:
- *sellerAddress:Address* - адрес аккаунта продавца
- *saleId:UInt64* - идентификатор продажи
- *amount:UFix64* - количество засылаемых Flow

### [`sale_order_withdraw.cdc`][sale_order_withdraw]

Отмена выставленного ордера.

Параметры:
- *saleId:UInt64* - идентификатор продажи


## Скрипты

### [`get_sale_ids.cdc`][get_sale_ids]

Возвращает список идентификаторов открытых ордеров.

Параметры:
- *address:Address* - адрес аккаунта-владельца ордеров

### [`sale_details.cdc`][sale_details]

Получить атрибуты заданного ордера.

Параметры:
- *id:UInt64* - идентификатор ордера
- *address:Address* - адрес аккаунта-владельца ордера


[init_show_case]: <https://github.com/rariblecom/flow-contracts/blob/main/cadence/transactions/showCase/init_show_case.cdc>
[regular_sale_create]: <https://github.com/rariblecom/flow-contracts/blob/main/cadence/transactions/showCase/regular_sale_create.cdc>
[regular_sale_purchase]: <https://github.com/rariblecom/flow-contracts/blob/main/cadence/transactions/showCase/regular_sale_purchase.cdc>
[sale_order_withdraw]: <https://github.com/rariblecom/flow-contracts/blob/main/cadence/transactions/showCase/sale_order_withdraw.cdc>
[get_sale_ids]: <https://github.com/rariblecom/flow-contracts/blob/main/cadence/scripts/showCase/get_sale_ids.cdc>
[sale_details]: <https://github.com/rariblecom/flow-contracts/blob/main/cadence/scripts/showCase/sale_details.cdc>
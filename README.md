# Двухфазный минт

## check
```cadence/scripts/commonNft/check.cdc```

Параметры:
* ```address:Address``` адрес аккаунта

Возвращает true если аккаунт инициализирован


## init
```cadence/transactions/commonNft/init.cdc```

Параметры:
* ```address:Address``` адрес аккаунта

Инициализация аккаунта подписанта

## mint-draft
```cadence/transactions/commonNft/mint_draft.cdc```

Параметры:
* ```creator:Address``` адрес создателя NFT (на него будет переведен токен)
* ```royalties:[NFTPlus.Royalties]``` роялти

События:
* ```MintDraft(id: Uint64, creator: Address, royalties: [CommonNFT.Royalties])```

Должен выполняться от сервисного аккаунта.
Создаёт в аккаунте пользователя заготовку для NFT.


## mint-item
```cadence/transactions/commonNft/mint_item.cdc```

Параметры:
* ```id:UInt64``` id заготовки (и впоследствии id NFT)
* ```creator:Address``` адрес создателя NFT (на него будет переведен токен)
* ```metadata:String``` ссылка на метадату

События:
* ```MintDraft(id: Uint64, creator: Address, royalties: [CommonNFT.Royalties])```

Должен выполняться от сервисного аккаунта.
Создаёт в аккаунте пользователя NFT по заготовке
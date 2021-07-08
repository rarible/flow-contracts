# NFTProvider

## events

### Mint

- `id (UInt64)` - идентификатор NFT
- `collection (String)` - коллекция
- `creator (Address)` - адрес аккаунта создателя
- `royalties ([NFTProvider.Royalties])` - список роялти
- `metadata (NFTProvider.Metadata)` - метаданные

Пример метаданных:

      NFTProvider.Metadata(
        uri: "https://pressa.tv/uploads/posts/2017-05/1493724117_950651-1493644486.jpg",
        title: "title", 
        description: "description", 
        properties: {}
      )

## transactions

### `nftProvider/mint_nft_to_address.cdc`

Минтит NFT и пересылает на указанный адрес, получатель записывается как создатель.

Параметры:

- `address: Address` - адрес получателя
- `collection: String` - коллекция
- `royalties: [NFTProvider.Royalties]` - список роялти
- `metadata: NFTProvider.Metadata` - метаданные

Пример параметров:

```
[
  {
    "type": "Address",
    "value": "0xf8d6e0586b0a20c7"
  },
  {
    "type": "String",
    "value": "rarible"
  },
  {
    "type": "Optional",
    "value": null
  },
  {
    "type": "Struct",
    "value": {
      "id": "A.f8d6e0586b0a20c7.NFTProvider.Metadata",
      "fields": [
        {
          "name": "uri",
          "value": {
            "type": "String",
            "value": "https://pressa.tv/uploads/posts/2017-05/1493724117_950651-1493644486.jpg"
          }
        },
        {
          "name": "title",
          "value": {
            "type": "String",
            "value": "title"
          }
        },
        {
          "name": "description",
          "value": {
            "type": "Optional",
            "value": {
              "type": "String",
              "value": "description"
            }
          }
        },
        {
          "name": "properties",
          "value": {
            "type": "Dictionary",
            "value": []
          }
        }
      ]
    }
  }
]
```

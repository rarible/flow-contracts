# Rarible Flow Smart Contracts

This repository contains the smart contracts and transactions for the [Flow](https://www.docs.onflow.org) blockchain used by Rarible marketplace.

The smart contracts are written in [Cadence](https://docs.onflow.org/cadence).

For more information, see [Rarible Protocol Flow documentation](https://docs.rarible.org/flow/flow-overview/).

## Addresses

| Contract     | Mainnet              | Testnet              |
|--------------|----------------------|----------------------|
| RaribleFee   | `0x336405ad2f289b87` | `0xebf4ae01d1284af8` |
| LicensedNFT  | `0x01ab36aaf654a13e` | `0xebf4ae01d1284af8` |
| RaribleNFT   | `0x01ab36aaf654a13e` | `0xebf4ae01d1284af8` |
| RaribleOrder | `0x01ab36aaf654a13e` | `0xebf4ae01d1284af8` |

## Smart contracts

* `RaribleFee` — fee manager that holds the rates and addresses fees.
* `LicensedNFT` — contract interface adds royalties to NFT. You can implement this `LicensedNFT` in your contract (along with [`NonFungibleToken`](https://github.com/onflow/flow-nft)), and your royalties will be taken when trading on [Rarible](https://rarible.com/).
* `RaribleNFT` — Rarible NFT contract that implements the [Flow NFT standard](https://github.com/onflow/flow-nft) is equivalent to ERC-721 or ERC-1155 on Ethereum.
* `RaribleOrder` — marketplace contract is the wrapper for the standard [NFTStorefront](https://github.com/onflow/nft-storefront) for handling market orders.

## Directory structure

The directories here are organized info contracts and transactions. Contracts contain the code that is deployed to
Flow.

* `contracts/` — where the Rarible related smart contracts live.
* `contracts/core/` — contains flow core contracts.
* `contracts/third-party/` — contains third-party NFT contracts supported by the market.
* `transactions/` — contains all the transactions and scripts that are associated with the Rarible smart
  contracts.
* `transactions/nft` — transactions and scripts for actions on supported NFT's.
* `transactions/storefront` — storefront actions for supported NFT's.

## Suggestions

You are welcome to [suggest features](https://github.com/rarible/protocol/discussions) and [report bugs found](https://github.com/rarible/protocol/issues)!

## Contributing

The codebase is maintained using the "contributor workflow" where everyone without exception contributes patch proposals using "pull requests" (PRs). This facilitates social contribution, easy testing, and peer review.

See more information on [CONTRIBUTING.md](https://github.com/rarible/protocol/blob/main/CONTRIBUTING.md).

## License

Rarible Flow Smart Contracts are available under the [GPL v3 license](LICENSE).

# Rarible smart contracts

This repository contains the smart contracts and transactions for the [Flow](https://www.docs.onflow.org) blockchain
used by Rarible marketplace.

The smart contracts are written in [Cadence](https://docs.onflow.org/cadence).

## Addresses

| Contract     | Mainnet              | Testnet              |
|--------------|----------------------|----------------------|
| RaribleFee   | `0x336405ad2f289b87` | `0xebf4ae01d1284af8` |
| LicensedNFT  | `0x01ab36aaf654a13e` | `0xebf4ae01d1284af8` |
| RaribleNFT   | `0x01ab36aaf654a13e` | `0xebf4ae01d1284af8` |
| RaribleOrder | `0x01ab36aaf654a13e` | `0xebf4ae01d1284af8` |

## Smart contracts

`RaribleFee`: This is simple fee manager that holds the rates and addresses for fees.

`LicensedNFT`: This is contract interface that adds royalties to NFT. You can implement this `LicensedNFT` in your
contract (along with [`NonFungibleToken`](https://github.com/onflow/flow-nft)) and your royalties will be taken when
trading on [Rarible](https://rarible.com/).

`RaribleNFT`: The Rarible NFT contract that implements the [Flow NFT standard](https://github.com/onflow/flow-nft)
which is equivalent to ERC-721 or ERC-1155 on Ethereum.

`RaribleOrder`: This marketplace contract is the wrapper for the
standard [NFTStorefront](https://github.com/onflow/nft-storefront)
for handling market orders.

## Directory structure

The directories here are organized info contracts and transactions. Contracts contain the code that are deployed to
Flow.

- `contracts/`: Where the Rarible related smart contracts live.
- `contracts/core/`: This contains flow core contracts.
- `contracts/third-party/`: This contains third party NFT contracts supported by the market.
- `transactions/`: This directory contains all the transactions and scripts that are associated with the Rarible smart
  contracts.
- `transactions/nft`: Transactions and scripts for actions on supported NFT's.
- `transactions/storefront`: Storefront actions for supported NFT's.

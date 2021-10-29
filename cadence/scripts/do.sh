#!/usr/bin/env bash

F="flow -n testnet"

# Generate key private/public key pair
#flow keys generate 

# Create account
#flow -n testnet accounts create --key ${PUBLIC_KEY}


#
# Init
#
#$F transactions send transactions/commonNft/init.cdc --signer master

#
# Mint
#  metadata: url://
#  royalties: [{"0x665b9acf64dfdfdb": 2.0}, {"0x665b9acf64dfdfdb": 5.0}]
#
#$F transactions send transactions/commonNft/mint.cdc --signer master --args-json '[{"type":"String","value":"url://"},{"type":"Array","value":[{"type":"Struct","value":{"id":"A.665b9acf64dfdfdb.RaribleNFT.Royalty","fields":[{"name":"address","value":{"type":"Address","value":"0x665b9acf64dfdfdb"}},{"name":"fee","value":{"type":"UFix64","value":"2.0"}}]}},{"type":"Struct","value":{"id":"A.665b9acf64dfdfdb.RaribleNFT.Royalty","fields":[{"name":"address","value":{"type":"Address","value":"0x665b9acf64dfdfdb"}},{"name":"fee","value":{"type":"UFix64","value":"5.0"}}]}}]}]'

#
# Burn
#  tokenId: 1
#
#$F transactions send transactions/commonNft/burn.cdc --signer master --arg UInt64:1

#
# Transfer
#  tokenId: 2
#  address: 0x665b9acf64dfdfdb
#
#$F transactions send transactions/commonNft/transfer.cdc --signer master --arg UInt64:2 --arg Address:0x665b9acf64dfdfdb

#
# Sell
#  tokenId: 3
#  amount: 0.123
#
#$F transactions send transactions/nftStorefront/sell_item.cdc --signer master --arg UInt64:3 --arg UFix64:0.123

#
# Buy
#  saleId: 10671852
#  address: 0x665b9acf64dfdfdb
#
#$F transactions send transactions/nftStorefront/buy_common-nft_flow.cdc --signer master --arg UInt64:10671852 --arg Address:0x665b9acf64dfdfdb

#
# Cleanup accepted sale
#  saleId: 10671852
#  address: 0x665b9acf64dfdfdb
#
#$F transactions send transactions/nftStorefront/cleanup_item.cdc --signer master --arg UInt64:10671852 --arg Address:0x665b9acf64dfdfdb

#
# Cancel sale
#  saleId: 10671852
#
#$F transactions send transactions/nftStorefront/remove_item.cdc --signer master --arg UInt64:10788740

#
# Owned NFT list
#  address: 0x665b9acf64dfdfdb
#
$F scripts execute scripts/commonNft/get_ids.cdc --arg Address:0x665b9acf64dfdfdb

#
# Owned NFT attributes
#  address: 0x665b9acf64dfdfdb
#  tokenId: 4
#  
#$F scripts execute scripts/commonNft/borrow_nft.cdc --arg Address:0x665b9acf64dfdfdb --arg UInt64:4

#
# Opened sales
#  address: 0x665b9acf64dfdfdb
#
$F scripts execute scripts/nftStorefront/read_storefront_ids.cdc --arg Address:0x665b9acf64dfdfdb


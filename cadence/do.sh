#!/usr/bin/env bash

F="flow -n testnet"

# Generate key private/public key pair
#flow keys generate 

# Create account
#flow -n testnet accounts create --key ${PUBLIC_KEY}


#
# Mint
#  metadata: url://
#  royalties: []
#
#$F transactions send transactions/commonNft/mint.cdc --signer master --args-json '[{"type":"String","value":"url://"},{"type":"Array","value":[]}]'

#
# Burn
#  tokenId: 1
#
#$F transactions send transactions/commonNft/burn.cdc --signer master --arg UInt64:1

#
# Transfer
#  tokenId: 2
#  address: 0xfcfb23c627a63d40
#
#$F transactions send transactions/commonNft/transfer.cdc --signer master --arg UInt64:2 --arg Address:0xfcfb23c627a63d40

#
# Sell
#  tokenId: 3
#  amount: 0.123
#
#$F transactions send transactions/showCase/regular_sale_create.cdc --signer master --arg UInt64:3 --arg UFix64:0.123

#
# Buy
#  address: 0xfcfb23c627a63d40
#  saleId: 10671852
#
#$F transactions send transactions/showCase/regular_sale_purchase_ext.cdc --signer master --arg Address:0xfcfb23c627a63d40 --arg UInt64:10671852

#
# Owned NFT list
#  address: 0xfcfb23c627a63d40
#
$F scripts execute scripts/commonNft/get_ids.cdc --arg Address:0xfcfb23c627a63d40

#
# Owned NFT attributes
#  address: 0xfcfb23c627a63d40
#  tokenId: 4
#  
$F scripts execute scripts/commonNft/borrow_nft.cdc --arg Address:0xfcfb23c627a63d40 --arg UInt64:4

#
# Opened sales
#  address: 0xfcfb23c627a63d40
#
$F scripts execute scripts/showCase/get_sale_ids.cdc --arg Address:0xfcfb23c627a63d40


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
#  royalties: [{"0xe91e497115b9731b": 2.0}, {"0xe91e497115b9731b": 5.0}]
#
#$F transactions send transactions/commonNft/mint.cdc --signer master --args-json '[{"type":"String","value":"url://"},{"type":"Array","value":[{"type":"Struct","value":{"id":"A.e91e497115b9731b.CommonNFT.Royalties","fields":[{"name":"address","value":{"type":"Address","value":"0xe91e497115b9731b"}},{"name":"fee","value":{"type":"UFix64","value":"2.0"}}]}},{"type":"Struct","value":{"id":"A.e91e497115b9731b.CommonNFT.Royalties","fields":[{"name":"address","value":{"type":"Address","value":"0xe91e497115b9731b"}},{"name":"fee","value":{"type":"UFix64","value":"5.0"}}]}}]}]'

#
# Burn
#  tokenId: 1
#
#$F transactions send transactions/commonNft/burn.cdc --signer master --arg UInt64:1

#
# Transfer
#  tokenId: 2
#  address: 0xe91e497115b9731b
#
#$F transactions send transactions/commonNft/transfer.cdc --signer master --arg UInt64:2 --arg Address:0xe91e497115b9731b

#
# Sell
#  tokenId: 3
#  amount: 0.123
#
#$F transactions send transactions/showCase/regular_sale_create.cdc --signer master --arg UInt64:3 --arg UFix64:0.123

#
# Buy
#  address: 0xe91e497115b9731b
#  saleId: 10671852
#
#$F transactions send transactions/showCase/regular_sale_purchase.cdc --signer master --arg Address:0xe91e497115b9731b --arg UInt64:10671852

#
# Cancel sale
#  saleId: 10671852
#
#$F transactions send transactions/showCase/sale_order_withdraw.cdc --signer master --arg UInt64:10788740

#
# Owned NFT list
#  address: 0xe91e497115b9731b
#
$F scripts execute scripts/commonNft/get_ids.cdc --arg Address:0xe91e497115b9731b

#
# Owned NFT attributes
#  address: 0xe91e497115b9731b
#  tokenId: 4
#  
#$F scripts execute scripts/commonNft/borrow_nft.cdc --arg Address:0xe91e497115b9731b --arg UInt64:4

#
# Opened sales
#  address: 0xe91e497115b9731b
#
$F scripts execute scripts/showCase/get_sale_ids.cdc --arg Address:0xe91e497115b9731b


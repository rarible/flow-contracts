#!/usr/bin/env bash

F="flow -n testnet"

# Generate key private/public key pair
#flow keys generate 

# Create account
#flow -n testnet accounts create --key ${PUBLIC_KEY}


#
# Mint draft
#  metadata: url://
#  royalties: [{"0xff1201e3a53ee578": 2.0}, {"0xff1201e3a53ee578": 5.0}]
#
#$F transactions send transactions/commonNft/mint-draft.cdc --signer master --args-json '[{"type":"Address","value":"0xff1201e3a53ee578"},{"type":"Array","value":[{"type":"Struct","value":{"id":"A.ff1201e3a53ee578.CommonNFT.Royalties","fields":[{"name":"address","value":{"type":"Address","value":"0xff1201e3a53ee578"}},{"name":"fee","value":{"type":"UFix64","value":"2.0"}}]}},{"type":"Struct","value":{"id":"A.ff1201e3a53ee578.CommonNFT.Royalties","fields":[{"name":"address","value":{"type":"Address","value":"0xff1201e3a53ee578"}},{"name":"fee","value":{"type":"UFix64","value":"5.0"}}]}}]}]'

#
# Mint item
#  metadata: url://
#  royalties: [{"0xff1201e3a53ee578": 2.0}, {"0xff1201e3a53ee578": 5.0}]
#
#$F transactions send transactions/commonNft/mint-item.cdc --signer master --args-json '[{"type":"UInt64","value":"0"},{"type":"Address","value":"0xff1201e3a53ee578"},{"type":"String","value":"url://"}]'

#
# Burn
#  tokenId: 1
#
#$F transactions send transactions/commonNft/burn.cdc --signer master --arg UInt64:1

#
# Transfer
#  tokenId: 2
#  address: 0xff1201e3a53ee578
#
#$F transactions send transactions/commonNft/transfer.cdc --signer master --arg UInt64:2 --arg Address:0xff1201e3a53ee578

#
# Sell
#  tokenId: 3
#  amount: 0.123
#
#$F transactions send transactions/showCase/regular_sale_create.cdc --signer master --arg UInt64:3 --arg UFix64:0.123

#
# Buy
#  address: 0xff1201e3a53ee578
#  saleId: 10671852
#
#$F transactions send transactions/showCase/regular_sale_purchase_ext.cdc --signer master --arg Address:0xff1201e3a53ee578 --arg UInt64:10671852

#
# Cancel sale
#  saleId: 10671852
#
#$F transactions send transactions/showCase/sale_order_withdraw.cdc --signer master --arg UInt64:10788740

#
# Owned NFT list
#  address: 0xff1201e3a53ee578
#
$F scripts execute scripts/commonNft/get_ids.cdc --arg Address:0xff1201e3a53ee578

#
# Owned NFT attributes
#  address: 0xff1201e3a53ee578
#  tokenId: 4
#  
#$F scripts execute scripts/commonNft/borrow_nft.cdc --arg Address:0xff1201e3a53ee578 --arg UInt64:4

#
# Opened sales
#  address: 0xff1201e3a53ee578
#
#$F scripts execute scripts/showCase/get_sale_ids.cdc --arg Address:0xff1201e3a53ee578


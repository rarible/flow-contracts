#!/usr/bin/env bash

MASTER=f8d6e0586b0a20c7

NFT0='[{"type":"String","value":"rarible"},{"type":"String","value":"http://ya.ru"},{"type":"String","value":"NFT Title"},{"type":"Optional","value":null},{"type":"Optional","value":null},{"type":"Optional","value":null},{"type":"Optional","value":null}]'
NFT1='[{"type":"Address","value":"'$MASTER'"},{"type":"String","value":"rarible"},{"type":"Optional","value":null},{"type":"Optional","value":null}]'
NFT2='[{"type":"Address","value":"0xf8d6e0586b0a20c7"},{"type":"String","value":"rarible"},{"type":"Optional","value":null},{"type":"Struct","value":{"id":"A.f8d6e0586b0a20c7.NFTProvider.Metadata","fields":[{"name":"uri","value":{"type":"String","value":"https://pressa.tv/uploads/posts/2017-05/1493724117_950651-1493644486.jpg"}},{"name":"title","value":{"type":"String","value":"title"}},{"name":"description","value":{"type":"String","value":"description"}},{"name":"properties","value":{"type":"Dictionary","value":[]}}]}}]'
#NFT3='[{"type":"Address","value":"0xf8d6e0586b0a20c7"},{"type":"String","value":"rarible"},{"type":"Optional","value":null},{"type":"Struct","value":{"id":"A.f8d6e0586b0a20c7.NFTProvider.Metadata","fields":[{"name":"uri","value":{"type":"String","value":"https://pressa.tv/uploads/posts/2017-05/1493724117_950651-1493644486.jpg"}},{"name":"title","value":{"type":"String","value":"title"}},{"name":"description","value":{"type":"Optional","value":null}},{"name":"properties","value":{"type":"Dictionary","value":[]}}]}}]'
NFT3='[{"type":"Address","value":"0xe4e5f90bf7e2a25f"},{"type":"String","value":"elbirar"},{"type":"Optional","value":null},{"type":"Struct","value":{"id":"A.e4e5f90bf7e2a25f.NFTProvider.Metadata","fields":[{"name":"uri","value":{"type":"String","value":"https://pressa.tv/uploads/posts/2017-05/1493724117_950651-1493644486.jpg"}},{"name":"title","value":{"type":"String","value":"title"}},{"name":"description","value":{"type":"Optional","value":null}},{"name":"properties","value":{"type":"Dictionary","value":[]}}]}}]'

NFT4='[{"type":"Address","value":"0xeeec6511cadbc0e2"},{"type":"String","value":"elbirar"},{"type":"Optional","value":null},{"type":"Struct","value":{"id":"A.e4e5f90bf7e2a25f.NFTProvider.Metadata","fields":[{"name":"uri","value":{"type":"String","value":"https://pressa.tv/uploads/posts/2017-05/1493724117_950651-1493644486.jpg"}},{"name":"title","value":{"type":"String","value":"title"}},{"name":"description","value":{"type":"Optional","value":null}},{"name":"properties","value":{"type":"Dictionary","value":[]}}]}}]'

NFT5='[{"type":"Address","value":"0x9e36413155144f5f"},{"type":"String","value":"elbirar"},{"type":"Optional","value":null},{"type":"Struct","value":{"id":"A.e4e5f90bf7e2a25f.NFTProvider.Metadata","fields":[{"name":"uri","value":{"type":"String","value":"https://pressa.tv/uploads/posts/2017-05/1493724117_950651-1493644486.jpg"}},{"name":"title","value":{"type":"String","value":"title"}},{"name":"description","value":{"type":"Optional","value":null}},{"name":"properties","value":{"type":"Dictionary","value":[]}}]}}]'

#flow transactions send transactions/nftProvider/init_holder.cdc --signer alice
#flow transactions send transactions/nftProvider/init_holder.cdc --signer bob
#flow transactions send transactions/nftProvider/init_holder.cdc --signer eve

#flow transactions send transactions/showCase/init_show_case.cdc --signer alice
#flow transactions send transactions/showCase/init_show_case.cdc --signer bob
#flow transactions send transactions/showCase/init_show_case.cdc --signer eve

# mint with public capability
#flow transactions send transactions/nftProvider/mint_nft_public.cdc --signer alice --args-json $NFT0
#flow transactions send transactions/nftProvider/mint_nft_public.cdc --signer bob --args-json $NFT0
#flow transactions send transactions/nftProvider/mint_nft_public.cdc --signer eve --args-json $NFT0

# mint from main account
flow -n testnet transactions send transactions/nftProvider/mint_nft_to_address.cdc --args-json "$NFT3" --signer master
flow -n testnet transactions send transactions/nftProvider/mint_nft_to_address.cdc --args-json "$NFT4" --signer master
flow -n testnet transactions send transactions/nftProvider/mint_nft_to_address.cdc --args-json "$NFT5" --signer master


#flow transactions send transactions/showCase/regular_sale_create.cdc --signer alice --arg UInt64:5 --arg UFix64:0.4
#flow transactions send transactions/showCase/regular_sale_purchase.cdc --arg Address:0x01cf0e2f2f715450 --arg UInt64:40 --arg UFix64:0.2
#flow transactions send transactions/showCase/regular_sale_withdraw.cdc --signer alice --arg UInt64:36

#for i in $(ls contracts/*); do echo \"$(basename $i)\" to \"$i\",; done

flow -n testnet transactions send transactions/nftProvider/mint_nft_to_address.cdc --args-json "$NFT3" --signer master
flow -n testnet transactions send transactions/nftProvider/mint_nft_to_address.cdc --args-json "$NFT4" --signer master
flow -n testnet transactions send transactions/nftProvider/mint_nft_to_address.cdc --args-json "$NFT5" --signer master

flow -n testnet transactions send transactions/nftProvider/mint_nft_to_address.cdc --args-json "$NFT3" --signer master
flow -n testnet transactions send transactions/nftProvider/mint_nft_to_address.cdc --args-json "$NFT4" --signer master
flow -n testnet transactions send transactions/nftProvider/mint_nft_to_address.cdc --args-json "$NFT5" --signer master

flow -n testnet transactions send transactions/nftProvider/mint_nft_to_address.cdc --args-json "$NFT3" --signer master
flow -n testnet transactions send transactions/nftProvider/mint_nft_to_address.cdc --args-json "$NFT4" --signer master
flow -n testnet transactions send transactions/nftProvider/mint_nft_to_address.cdc --args-json "$NFT5" --signer master

flow -n testnet transactions send transactions/nftProvider/mint_nft_to_address.cdc --args-json "$NFT3" --signer master
flow -n testnet transactions send transactions/nftProvider/mint_nft_to_address.cdc --args-json "$NFT4" --signer master
flow -n testnet transactions send transactions/nftProvider/mint_nft_to_address.cdc --args-json "$NFT5" --signer master

flow -n testnet transactions send transactions/nftProvider/mint_nft_to_address.cdc --args-json "$NFT3" --signer master
flow -n testnet transactions send transactions/nftProvider/mint_nft_to_address.cdc --args-json "$NFT4" --signer master
flow -n testnet transactions send transactions/nftProvider/mint_nft_to_address.cdc --args-json "$NFT5" --signer master

flow -n testnet transactions send transactions/nftProvider/mint_nft_to_address.cdc --args-json "$NFT3" --signer master
flow -n testnet transactions send transactions/nftProvider/mint_nft_to_address.cdc --args-json "$NFT4" --signer master
flow -n testnet transactions send transactions/nftProvider/mint_nft_to_address.cdc --args-json "$NFT5" --signer master

flow -n testnet transactions send transactions/nftProvider/mint_nft_to_address.cdc --args-json "$NFT3" --signer master
flow -n testnet transactions send transactions/nftProvider/mint_nft_to_address.cdc --args-json "$NFT4" --signer master
flow -n testnet transactions send transactions/nftProvider/mint_nft_to_address.cdc --args-json "$NFT5" --signer master

flow -n testnet transactions send transactions/nftProvider/mint_nft_to_address.cdc --args-json "$NFT3" --signer master
flow -n testnet transactions send transactions/nftProvider/mint_nft_to_address.cdc --args-json "$NFT4" --signer master
flow -n testnet transactions send transactions/nftProvider/mint_nft_to_address.cdc --args-json "$NFT5" --signer master

flow -n testnet transactions send transactions/nftProvider/mint_nft_to_address.cdc --args-json "$NFT3" --signer master
flow -n testnet transactions send transactions/nftProvider/mint_nft_to_address.cdc --args-json "$NFT4" --signer master
flow -n testnet transactions send transactions/nftProvider/mint_nft_to_address.cdc --args-json "$NFT5" --signer master

flow -n testnet transactions send transactions/nftProvider/mint_nft_to_address.cdc --args-json "$NFT3" --signer master
flow -n testnet transactions send transactions/nftProvider/mint_nft_to_address.cdc --args-json "$NFT4" --signer master
flow -n testnet transactions send transactions/nftProvider/mint_nft_to_address.cdc --args-json "$NFT5" --signer master

flow -n testnet transactions send transactions/nftProvider/mint_nft_to_address.cdc --args-json "$NFT3" --signer master
flow -n testnet transactions send transactions/nftProvider/mint_nft_to_address.cdc --args-json "$NFT4" --signer master
flow -n testnet transactions send transactions/nftProvider/mint_nft_to_address.cdc --args-json "$NFT5" --signer master

flow -n testnet transactions send transactions/nftProvider/mint_nft_to_address.cdc --args-json "$NFT3" --signer master
flow -n testnet transactions send transactions/nftProvider/mint_nft_to_address.cdc --args-json "$NFT4" --signer master
flow -n testnet transactions send transactions/nftProvider/mint_nft_to_address.cdc --args-json "$NFT5" --signer master

flow -n testnet transactions send transactions/nftProvider/mint_nft_to_address.cdc --args-json "$NFT3" --signer master
flow -n testnet transactions send transactions/nftProvider/mint_nft_to_address.cdc --args-json "$NFT4" --signer master
flow -n testnet transactions send transactions/nftProvider/mint_nft_to_address.cdc --args-json "$NFT5" --signer master

flow -n testnet transactions send transactions/nftProvider/mint_nft_to_address.cdc --args-json "$NFT3" --signer master
flow -n testnet transactions send transactions/nftProvider/mint_nft_to_address.cdc --args-json "$NFT4" --signer master
flow -n testnet transactions send transactions/nftProvider/mint_nft_to_address.cdc --args-json "$NFT5" --signer master

flow -n testnet transactions send transactions/nftProvider/mint_nft_to_address.cdc --args-json "$NFT3" --signer master
flow -n testnet transactions send transactions/nftProvider/mint_nft_to_address.cdc --args-json "$NFT4" --signer master
flow -n testnet transactions send transactions/nftProvider/mint_nft_to_address.cdc --args-json "$NFT5" --signer master

flow -n testnet transactions send transactions/nftProvider/mint_nft_to_address.cdc --args-json "$NFT3" --signer master
flow -n testnet transactions send transactions/nftProvider/mint_nft_to_address.cdc --args-json "$NFT4" --signer master
flow -n testnet transactions send transactions/nftProvider/mint_nft_to_address.cdc --args-json "$NFT5" --signer master

flow -n testnet transactions send transactions/nftProvider/mint_nft_to_address.cdc --args-json "$NFT3" --signer master
flow -n testnet transactions send transactions/nftProvider/mint_nft_to_address.cdc --args-json "$NFT4" --signer master
flow -n testnet transactions send transactions/nftProvider/mint_nft_to_address.cdc --args-json "$NFT5" --signer master

flow -n testnet transactions send transactions/nftProvider/mint_nft_to_address.cdc --args-json "$NFT3" --signer master
flow -n testnet transactions send transactions/nftProvider/mint_nft_to_address.cdc --args-json "$NFT4" --signer master
flow -n testnet transactions send transactions/nftProvider/mint_nft_to_address.cdc --args-json "$NFT5" --signer master

flow -n testnet transactions send transactions/nftProvider/mint_nft_to_address.cdc --args-json "$NFT3" --signer master
flow -n testnet transactions send transactions/nftProvider/mint_nft_to_address.cdc --args-json "$NFT4" --signer master
flow -n testnet transactions send transactions/nftProvider/mint_nft_to_address.cdc --args-json "$NFT5" --signer master

flow -n testnet transactions send transactions/nftProvider/mint_nft_to_address.cdc --args-json "$NFT3" --signer master
flow -n testnet transactions send transactions/nftProvider/mint_nft_to_address.cdc --args-json "$NFT4" --signer master
flow -n testnet transactions send transactions/nftProvider/mint_nft_to_address.cdc --args-json "$NFT5" --signer master

flow -n testnet transactions send transactions/nftProvider/mint_nft_to_address.cdc --args-json "$NFT3" --signer master
flow -n testnet transactions send transactions/nftProvider/mint_nft_to_address.cdc --args-json "$NFT4" --signer master
flow -n testnet transactions send transactions/nftProvider/mint_nft_to_address.cdc --args-json "$NFT5" --signer master

flow -n testnet transactions send transactions/nftProvider/mint_nft_to_address.cdc --args-json "$NFT3" --signer master
flow -n testnet transactions send transactions/nftProvider/mint_nft_to_address.cdc --args-json "$NFT4" --signer master
flow -n testnet transactions send transactions/nftProvider/mint_nft_to_address.cdc --args-json "$NFT5" --signer master

flow -n testnet transactions send transactions/nftProvider/mint_nft_to_address.cdc --args-json "$NFT3" --signer master
flow -n testnet transactions send transactions/nftProvider/mint_nft_to_address.cdc --args-json "$NFT4" --signer master
flow -n testnet transactions send transactions/nftProvider/mint_nft_to_address.cdc --args-json "$NFT5" --signer master

flow -n testnet transactions send transactions/nftProvider/mint_nft_to_address.cdc --args-json "$NFT3" --signer master
flow -n testnet transactions send transactions/nftProvider/mint_nft_to_address.cdc --args-json "$NFT4" --signer master
flow -n testnet transactions send transactions/nftProvider/mint_nft_to_address.cdc --args-json "$NFT5" --signer master

flow -n testnet transactions send transactions/nftProvider/mint_nft_to_address.cdc --args-json "$NFT3" --signer master
flow -n testnet transactions send transactions/nftProvider/mint_nft_to_address.cdc --args-json "$NFT4" --signer master
flow -n testnet transactions send transactions/nftProvider/mint_nft_to_address.cdc --args-json "$NFT5" --signer master


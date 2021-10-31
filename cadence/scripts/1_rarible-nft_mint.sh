#!/usr/bin/env bash
. env.sh

$TXS transactions/nft/rarible-nft/mint.cdc --args-json '['"$(metadata "ipfs://nft1")"',{"type":"Array","value":['"$(royalty $BOB 0.012)"','"$(royalty $EVE 0.008)"']}]'
$TXS transactions/nft/rarible-nft/mint.cdc --args-json '['"$(metadata "ipfs://nft2")"',{"type":"Array","value":['"$(royalty $BOB 0.012)"','"$(royalty $EVE 0.008)"']}]'

$TX $alice transactions/nft/rarible-nft/mint.cdc --args-json '['"$(metadata "ipfs://nft3")"',{"type":"Array","value":['"$(royalty $BOB 0.012)"','"$(royalty $EVE 0.008)"']}]'
$TX $alice transactions/nft/rarible-nft/mint.cdc --args-json '['"$(metadata "ipfs://nft4")"',{"type":"Array","value":['"$(royalty $BOB 0.012)"','"$(royalty $EVE 0.008)"']}]'

$TX $bob transactions/nft/rarible-nft/mint.cdc --args-json '['"$(metadata "ipfs://nft5")"',{"type":"Array","value":['"$(royalty $BOB 0.012)"','"$(royalty $EVE 0.008)"']}]'
$TX $bob transactions/nft/rarible-nft/mint.cdc --args-json '['"$(metadata "ipfs://nft6")"',{"type":"Array","value":['"$(royalty $BOB 0.012)"','"$(royalty $EVE 0.008)"']}]'

$TX $eve transactions/nft/rarible-nft/mint.cdc --args-json '['"$(metadata "ipfs://nft7")"',{"type":"Array","value":['"$(royalty $BOB 0.012)"','"$(royalty $EVE 0.008)"']}]'
$TX $eve transactions/nft/rarible-nft/mint.cdc --args-json '['"$(metadata "ipfs://nft8")"',{"type":"Array","value":['"$(royalty $BOB 0.012)"','"$(royalty $EVE 0.008)"']}]'

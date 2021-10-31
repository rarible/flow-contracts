#!/usr/bin/env bash
. env.sh

royalty() {
    echo '{"type":"Struct","value":{"id":"A.'"$CONTRACT"'.RaribleNFT.Royalty","fields":[{"name":"address","value":{"type":"Address","value":"'"$1"'"}},{"name":"fee","value":{"type":"UFix64","value":"'"$2"'"}}]}}'
}

metadata() {
  echo '{"type":"String","value":"'"$1"'"}'
}

$TXS transactions/common-nft/mint.cdc --args-json '['"$(metadata "ipfs://nft1")"',{"type":"Array","value":['"$(royalty $BOB 0.012)"','"$(royalty $EVE 0.008)"']}]'
$TXS transactions/common-nft/mint.cdc --args-json '['"$(metadata "ipfs://nft2")"',{"type":"Array","value":['"$(royalty $BOB 0.012)"','"$(royalty $EVE 0.008)"']}]'

$TX $alice transactions/common-nft/mint.cdc --args-json '['"$(metadata "ipfs://nft3")"',{"type":"Array","value":['"$(royalty $BOB 0.012)"','"$(royalty $EVE 0.008)"']}]'
$TX $alice transactions/common-nft/mint.cdc --args-json '['"$(metadata "ipfs://nft4")"',{"type":"Array","value":['"$(royalty $BOB 0.012)"','"$(royalty $EVE 0.008)"']}]'

$TX $bob transactions/common-nft/mint.cdc --args-json '['"$(metadata "ipfs://nft5")"',{"type":"Array","value":['"$(royalty $BOB 0.012)"','"$(royalty $EVE 0.008)"']}]'
$TX $bob transactions/common-nft/mint.cdc --args-json '['"$(metadata "ipfs://nft6")"',{"type":"Array","value":['"$(royalty $BOB 0.012)"','"$(royalty $EVE 0.008)"']}]'

$TX $eve transactions/common-nft/mint.cdc --args-json '['"$(metadata "ipfs://nft7")"',{"type":"Array","value":['"$(royalty $BOB 0.012)"','"$(royalty $EVE 0.008)"']}]'
$TX $eve transactions/common-nft/mint.cdc --args-json '['"$(metadata "ipfs://nft8")"',{"type":"Array","value":['"$(royalty $BOB 0.012)"','"$(royalty $EVE 0.008)"']}]'

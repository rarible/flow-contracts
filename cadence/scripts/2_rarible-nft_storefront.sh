#!/usr/bin/env bash
. env.sh

echo "********** RaribleNFT **********"

$TX $alice transactions/storefront/rarible-nft/sell_flow.cdc 2 1.0
$TX $bob transactions/storefront/rarible-nft/buy_flow.cdc 100 $ALICE

$TX $alice transactions/storefront/rarible-nft/sell_fusd.cdc 3 1.0
$TX $bob transactions/storefront/rarible-nft/buy_fusd.cdc 109 $ALICE

#!/usr/bin/env bash
. env.sh

echo "********** CommonNFT **********"

$TX $alice transactions/storefront/common-nft/sell_flow.cdc 2 1.0
$TX $bob transactions/storefront/common-nft/buy_flow.cdc 100 $ALICE

$TX $alice transactions/storefront/common-nft/sell_fusd.cdc 3 1.0
$TX $bob transactions/storefront/common-nft/buy_fusd.cdc 109 $ALICE

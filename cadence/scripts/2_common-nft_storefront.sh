#!/usr/bin/env bash
. env.sh

echo "********** CommonNFT **********"

$TX $alice transactions/storefront/commonNft/sell_common-nft_flow.cdc 2 1.0
$TX $bob transactions/storefront/commonNft/buy_common-nft_flow.cdc 100 $ALICE

$TX $alice transactions/storefront/commonNft/sell_common-nft_fusd.cdc 3 1.0
$TX $bob transactions/storefront/commonNft/buy_common-nft_fusd.cdc 109 $ALICE

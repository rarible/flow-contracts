#!/usr/bin/env bash
. env.sh

echo "********** CommonNFT **********"

$TX $alice transactions/nftStorefront/sell_common-nft_flow.cdc 2 1.0
$TX $bob transactions/nftStorefront/buy_common-nft_flow.cdc 131 $ALICE

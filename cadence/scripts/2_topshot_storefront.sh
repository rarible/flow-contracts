#!/usr/bin/env bash
. env.sh

echo "********** TopShot **********"

$TX $alice transactions/storefront/topshot/sell_flow.cdc 12 1.0
$SC transactions/storefront/scripts/read_storefront_ids.cdc $ALICE
$SC transactions/storefront/scripts/read_listing_details.cdc $ALICE 1837
$TX $bob transactions/storefront/topshot/buy_flow.cdc 1837 $ALICE

$TX $alice transactions/storefront/topshot/sell_fusd.cdc 13 1.0
$SC transactions/storefront/scripts/read_storefront_ids.cdc $ALICE
$SC transactions/storefront/scripts/read_listing_details.cdc $ALICE 1839
$TX $bob transactions/storefront/topshot/buy_fusd.cdc 1839 $ALICE

echo Alice items
$SC transactions/custom/topshot/scripts/get_ids_topshot.cdc $ALICE

echo Bob items
$SC transactions/custom/topshot/scripts/get_ids_topshot.cdc $BOB


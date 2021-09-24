#!/usr/bin/env bash
. env.sh

echo $TX $alice transactions/sell_item.cdc 1 1.0
$TX $alice transactions/sell_item.cdc 1 1.0
echo $SC scripts/read_storefront_ids.cdc $ALICE
$SC scripts/read_storefront_ids.cdc $ALICE
echo $SC scripts/read_sale_offer_details.cdc $ALICE 97
$SC scripts/read_sale_offer_details.cdc $ALICE 97

read -r -p "Alice sell NFT for 1.0 flow. Press enter to continue"

echo $TX $bob transactions/buy_item.cdc 97 $ALICE
$TX $bob transactions/buy_item.cdc 97 $ALICE

echo Alice items
$SC scripts/get_ids.cdc $ALICE

echo Bob items
$SC scripts/get_ids.cdc $BOB

read -r -p "Bob buy Alice's item. Press enter to continue"

echo $TX $eve transactions/sell_item.cdc 37 5.0
$TX $eve transactions/sell_item.cdc 37 5.0

echo $TX $eve transactions/remove_item.cdc 103
$TX $eve transactions/remove_item.cdc 103

read -r -p "Eve create sale offer and cancel it. Press enter to finish"

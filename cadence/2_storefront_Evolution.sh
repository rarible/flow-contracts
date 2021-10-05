#!/usr/bin/env bash
. env.sh

echo "********** Evolution **********"

$TX $alice transactions/sell_evolution_flow.cdc 1 1.0
$SC scripts/nftStorefront/read_storefront_ids.cdc $ALICE
$SC scripts/nftStorefront/read_listing_details.cdc $ALICE 139

#read -r -p "Alice sell NFT for 1.0 flow. Press enter to continue"

$TX $bob transactions/buy_evolution_flow.cdc 139 $ALICE

echo Alice items
$SC scripts/get_ids_evolution.cdc $ALICE

echo Bob items
$SC scripts/get_ids_evolution.cdc $BOB

#read -r -p "Bob buy Alice's item. Press enter to continue"

$TX $eve transactions/sell_evolution_flow.cdc 37 5.0

$TX $eve transactions/nftStorefront/remove_item.cdc 145

#read -r -p "Eve create sale offer and cancel it. Press enter to finish"

#!/usr/bin/env bash
. env.sh

echo "********** Evolution **********"

$TX $alice transactions/storefront/evolution/sell_flow.cdc 1 1.0
$SC transactions/storefront/scripts/read_ids.cdc $ALICE
$SC transactions/storefront/scripts/read_details.cdc $ALICE 188
$TX $bob transactions/storefront/evolution/buy_flow.cdc 188 $ALICE

$TX $alice transactions/storefront/evolution/sell_fusd.cdc 2 1.0
$SC transactions/storefront/scripts/read_ids.cdc $ALICE
$SC transactions/storefront/scripts/read_details.cdc $ALICE 195
$TX $bob transactions/storefront/evolution/buy_fusd.cdc 195 $ALICE

echo Alice items
$SC transactions/custom/evolution/scripts/get_evolution.cdc $ALICE

echo Bob items
$SC transactions/custom/evolution/scripts/get_evolution.cdc $BOB

#read -r -p "Bob buy Alice's item. Press enter to continue"

$TX $eve transactions/storefront/evolution/sell_flow.cdc 37 5.0

$TX $eve transactions/storefront/remove_item.cdc 203

#read -r -p "Eve create sale offer and cancel it. Press enter to finish"

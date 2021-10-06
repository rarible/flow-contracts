#!/usr/bin/env bash
. env.sh

echo "********** MotoGP **********"

# sell card
$TX $alice transactions/sell_motogp-card_flow.cdc 1 0.125

$SC scripts/nftStorefront/read_storefront_ids.cdc $ALICE
$SC scripts/nftStorefront/read_listing_details.cdc $ALICE 146

#read -r -p "Alice have a sale. Press enter to continue"

$TX $bob transactions/buy_motogp-card_flow.cdc 146 $ALICE

echo "Alices cards:"
$SC scripts/get_ids_motogp-card.cdc $ALICE
echo "Bob cards:"
$SC scripts/get_ids_motogp-card.cdc $BOB

#read -r -p "Service buy a Alice's card. Press CTRL-C"



################################################################################
# Storefront
################################################################################

# read opened sales ids
# @param storefrontAddress
$SC scripts/nftStorefront/read_storefront_ids.cdc $ALICE

# read sale detail
# @param storefrontAddress
# @param saleId
#$SC scripts/nftStorefront/read_listing_details.cdc $ALICE 139

# sell pack
# @param packId
# @param price
#$TXS transactions/sell_pack.cdc 0 0.1

# buy pack
# @param saleId
# @param storefrontAddress
#$TXS transactions/buy_pack.cdc 31 $SERVICE

# sell card
# @param cardId
# @param price
$TX $bob transactions/sell_motogp-card_flow.cdc 4 0.1

# buy card
# @param saleId
# @param storefrontAddress
$TX $eve transactions/buy_motogp-card_flow.cdc 152 $BOB


# read metadata on mainnet

# ids list
#flow -n mainnet scripts execute scripts/get_ids_motogp-card.cdc 0x6315e44b670d3d00

# metadata
#flow -n mainnet scripts execute scripts/borrow_card_metadata.cdc 0x6315e44b670d3d00 10474

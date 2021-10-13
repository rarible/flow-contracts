#!/usr/bin/env bash
. env.sh

echo "********** MotoGP **********"

# sell card
$TX $alice transactions/storefront/motogp-card/sell_motogp-card_flow.cdc 1 0.125
$SC transactions/storefront/scripts/read_storefront_ids.cdc $ALICE
$SC transactions/storefront/scripts/read_listing_details.cdc $ALICE 122
$TX $bob transactions/storefront/motogp-card/buy_motogp-card_flow.cdc 122 $ALICE

# sell card
$TX $alice transactions/storefront/motogp-card/sell_motogp-card_fusd.cdc 2 0.125
$SC transactions/storefront/scripts/read_storefront_ids.cdc $ALICE
$SC transactions/storefront/scripts/read_listing_details.cdc $ALICE 129
$TX $bob transactions/storefront/motogp-card/buy_motogp-card_fusd.cdc 129 $ALICE

echo "Alices cards:"
$SC transactions/custom/motogp-card/scripts/get_ids_motogp-card.cdc $ALICE
echo "Bob cards:"
$SC transactions/custom/motogp-card/scripts/get_ids_motogp-card.cdc $BOB

#read -r -p "Service buy a Alice's card. Press CTRL-C"



################################################################################
# Storefront
################################################################################

# read opened sales ids
# @param storefrontAddress
$SC transactions/storefront/scripts/read_storefront_ids.cdc $ALICE

# read sale detail
# @param storefrontAddress
# @param saleId
#$SC scripts/storefront/read_listing_details.cdc $ALICE 139

# sell pack
# @param packId
# @param price
#$TXS transactions/storefront/motogp-card/sell_pack.cdc 0 0.1

# buy pack
# @param saleId
# @param storefrontAddress
#$TXS transactions/storefront/motogp-card/buy_pack.cdc 31 $SERVICE

# sell card
# @param cardId
# @param price
$TX $bob transactions/storefront/motogp-card/sell_motogp-card_flow.cdc 4 0.1

# buy card
# @param saleId
# @param storefrontAddress
$TX $eve transactions/storefront/motogp-card/buy_motogp-card_flow.cdc 137 $BOB


# read metadata on mainnet

# ids list
#flow -n mainnet scripts execute scripts/get_ids_motogp-card.cdc 0x6315e44b670d3d00

# metadata
#flow -n mainnet scripts execute scripts/borrow_card_metadata.cdc 0x6315e44b670d3d00 10474

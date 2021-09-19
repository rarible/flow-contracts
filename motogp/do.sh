#!/usr/bin/env bash

. env.sh

$FLOW transactions send transactions/setup.cdc --signer service
$FLOW transactions send transactions/setup.cdc --signer alice
$FLOW transactions send transactions/setup.cdc --signer bob
$FLOW transactions send transactions/setup.cdc --signer eve

# add 0 and 1 pack types
$FLOW transactions send transactions/add_pack_type.cdc 0 --signer service
$FLOW transactions send transactions/add_pack_type.cdc 1 --signer service

# empty after setup
$FLOW scripts execute scripts/get_pack_ids.cdc $ALICE
$FLOW scripts execute scripts/get_card_ids.cdc $ALICE

# mint pack to alice
$FLOW transactions send transactions/mint_pack_to_address.cdc [$ALICE] [0] [[1]] --signer service

$FLOW scripts execute scripts/get_pack_ids.cdc $ALICE
$FLOW scripts execute scripts/borrow_pack.cdc $ALICE 0

read -r -p "Now minted one pack to Alice. Press enter to continue"

# transfer to pack opener
$FLOW transactions send transactions/transfer_pack_to_pack_opener.cdc 0 $ALICE --signer alice

# open pack
$FLOW transactions send transactions/open_pack.cdc $ALICE 0 [1,2,3] [1,2,3] --signer service

$FLOW scripts execute scripts/get_card_ids.cdc $ALICE
$FLOW scripts execute scripts/borrow_card.cdc $ALICE 1
$FLOW scripts execute scripts/borrow_card.cdc $ALICE 2
$FLOW scripts execute scripts/borrow_card.cdc $ALICE 3

read -r -p "Now Alice have a cards. Press enter to continue"

# sell card
$FLOW transactions send transactions/sell_card.cdc 1 0.125 --signer alice

$FLOW scripts execute scripts/read_storefront_ids.cdc $ALICE
$FLOW scripts execute scripts/read_sale_offer_details.cdc $ALICE 32

read -r -p "Alice have a sale. Press enter to continue"

$FLOW transactions send transactions/buy_card.cdc 32 $ALICE --signer service

echo "Alices cards:"
$FLOW scripts execute scripts/get_card_ids.cdc $ALICE
echo "Services cards:"
$FLOW scripts execute scripts/get_card_ids.cdc $SERVICE

read -r -p "Service buy a Alice's card. Press CTRL-C"


# mint pack to address
# execute from service
# @param addresses array
# @param pack types array
# @param pack numbers array
$FLOW transactions send transactions/mint_pack_to_address.cdc [$ALICE] [0] [[11]]

# open pack (highly likely)
# execute from service
# @param recepient address
# @param pack id (must be in the recipients pack opener storage)
# @param card numbers
# @param card serials
$FLOW transactions send transactions/open_pack.cdc 0x01cf0e2f2f715450 5 [1,2,3] [1,2,3]


################################################################################
# Storefront
################################################################################

# read opened sales ids
# @param storefrontAddress
$FLOW scripts execute scripts/read_storefront_ids.cdc $SERVICE

# read sale detail
# @param storefrontAddress
# @param saleId
$FLOW scripts execute scripts/read_sale_offer_details.cdc $SERVICE 31

# sell pack
# @param packId
# @param price
$FLOW transactions send transactions/sell_pack.cdc 0 0.1

# buy pack
# @param saleId
# @param storefrontAddress
$FLOW transactions send transactions/buy_pack.cdc 31 $SERVICE

# sell card
# @param cardId
# @param price
$FLOW transactions send transactions/sell_card.cdc 0 0.1

# buy card
# @param saleId
# @param storefrontAddress
$FLOW transactions send transactions/buy_card.cdc 31 $SERVICE


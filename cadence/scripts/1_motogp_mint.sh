#!/usr/bin/env bash
. env.sh

# add 0 and 1 pack types
$TX $tpservice transactions/custom/motogp-card/m_add_pack_type.cdc 0
$TX $tpservice transactions/custom/motogp-card/m_add_pack_type.cdc 1

# empty after setup
$SC transactions/custom/motogp-card/m_get_pack_ids.cdc $ALICE
$SC transactions/custom/motogp-card/m_get_card_ids.cdc $ALICE

# mint pack to alice
$TX $tpservice transactions/custom/motogp-card/m_mint_pack_to_address.cdc [$ALICE] [0] [[1]]
$TX $tpservice transactions/custom/motogp-card/m_mint_pack_to_address.cdc [$BOB] [0] [[2]]

$SC transactions/custom/motogp-card/m_get_pack_ids.cdc $ALICE
$SC transactions/custom/motogp-card/m_borrow_pack.cdc $ALICE 0

#read -r -p "Now minted one pack to Alice. Press enter to continue"

# transfer to pack opener
$TX $alice transactions/custom/motogp-card/m_transfer_pack_to_pack_opener.cdc 0 $ALICE
$TX $bob transactions/custom/motogp-card/m_transfer_pack_to_pack_opener.cdc 1 $BOB

# open pack
$TX $tpservice transactions/custom/motogp-card/m_open_pack.cdc $ALICE 0 [1,2,3] [1,2,3]
$TX $tpservice transactions/custom/motogp-card/m_open_pack.cdc $BOB 1 [12,22,32] [12,22,32]

$SC transactions/custom/motogp-card/m_get_card_ids.cdc $ALICE
$SC transactions/custom/motogp-card/m_borrow_card.cdc $ALICE 1
$SC transactions/custom/motogp-card/m_borrow_card.cdc $ALICE 2
$SC transactions/custom/motogp-card/m_borrow_card.cdc $ALICE 3

#read -r -p "Now Alice have a cards. Press enter to continue"

# mint pack to address
# execute from service
# @param addresses array
# @param pack types array
# @param pack numbers array
$TX $tpservice transactions/custom/motogp-card/m_mint_pack_to_address.cdc [$EVE] [0] [[11]]

$TX $eve transactions/custom/motogp-card/m_transfer_pack_to_pack_opener.cdc 2 $EVE

# open pack (highly likely)
# execute from service
# @param recipient address
# @param pack id (must be in the recipients pack opener storage)
# @param card numbers
# @param card serials
$TX $tpservice transactions/custom/motogp-card/m_open_pack.cdc $EVE 2 [4,5,6] [1,2,3]

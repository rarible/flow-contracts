#!/usr/bin/env bash
. env.sh

$TXS custom/e_t1.cdc $ALICE 1 2
$TXS custom/e_t1.cdc $ALICE 1 5

$TXS custom/e_t1.cdc $BOB 2 4
$TXS custom/e_t1.cdc $BOB 1 8

$TXS custom/e_t1.cdc $EVE 1 13
$TXS custom/e_t1.cdc $EVE 2 11

echo "Alice nft's:"
$SC scripts/get_ids_evolution.cdc $ALICE

echo "Bob nft's:"
$SC scripts/get_ids_evolution.cdc $BOB

echo "Eve nft's:"
$SC scripts/get_ids_evolution.cdc $EVE

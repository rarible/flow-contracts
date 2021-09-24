#!/usr/bin/env bash
. env.sh

$TXS custom/t1.cdc $ALICE 1 2
$TXS custom/t1.cdc $ALICE 1 5

$TXS custom/t1.cdc $BOB 2 4
$TXS custom/t1.cdc $BOB 1 8

$TXS custom/t1.cdc $EVE 1 13
$TXS custom/t1.cdc $EVE 2 11

echo "Alice nft's:"
$SC scripts/get_ids.cdc $ALICE

echo "Bob nft's:"
$SC scripts/get_ids.cdc $BOB

echo "Eve nft's:"
$SC scripts/get_ids.cdc $EVE

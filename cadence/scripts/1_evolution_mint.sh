#!/usr/bin/env bash
. env.sh

$TX $tpservice transactions/custom/evolution/e_t1.cdc $ALICE 1 2
$TX $tpservice transactions/custom/evolution/e_t1.cdc $ALICE 1 5

$TX $tpservice transactions/custom/evolution/e_t1.cdc $BOB 2 4
$TX $tpservice transactions/custom/evolution/e_t1.cdc $BOB 1 8

$TX $tpservice transactions/custom/evolution/e_t1.cdc $EVE 1 13
$TX $tpservice transactions/custom/evolution/e_t1.cdc $EVE 2 11

echo "Alice nft's:"
$SC transactions/custom/evolution/scripts/get_ids_evolution.cdc $ALICE

echo "Bob nft's:"
$SC transactions/custom/evolution/scripts/get_ids_evolution.cdc $BOB

echo "Eve nft's:"
$SC transactions/custom/evolution/scripts/get_ids_evolution.cdc $EVE

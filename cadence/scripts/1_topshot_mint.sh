#!/usr/bin/env bash
. env.sh

# mint moment
$TXS transactions/custom/topshot/t_mint_moment.cdc 4 1 $SERVICE

# batch mint moment
$TXS transactions/custom/topshot/t_batch_mint_moment.cdc 6 7 10 $SERVICE

$TXS transactions/custom/topshot/t_batch_mint_moment.cdc 42 1478 5 $ALICE
$TXS transactions/custom/topshot/t_batch_mint_moment.cdc 42 1512 5 $ALICE

$TXS transactions/custom/topshot/t_batch_mint_moment.cdc 24 320 10 $BOB
$TXS transactions/custom/topshot/t_batch_mint_moment.cdc 24 322 10 $BOB

$TXS transactions/custom/topshot/t_batch_mint_moment.cdc 12 147 7 $EVE
$TXS transactions/custom/topshot/t_batch_mint_moment.cdc 12 161 7 $EVE

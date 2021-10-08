#!/usr/bin/env bash
. env.sh

# mint moment
$TXS custom/t_mint_moment.cdc 4 1 $SERVICE

# batch mint moment
$TXS custom/t_batch_mint_moment.cdc 6 7 10 $SERVICE

$TXS custom/t_batch_mint_moment.cdc 42 1478 5 $ALICE
$TXS custom/t_batch_mint_moment.cdc 42 1512 5 $ALICE

$TXS custom/t_batch_mint_moment.cdc 24 320 10 $BOB
$TXS custom/t_batch_mint_moment.cdc 24 322 10 $BOB

$TXS custom/t_batch_mint_moment.cdc 12 147 7 $EVE
$TXS custom/t_batch_mint_moment.cdc 12 161 7 $EVE

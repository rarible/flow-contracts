#!/usr/bin/env bash
. env.sh

$FLOW project deploy

#create accounts (only for emulator)
$FLOW accounts create --key 6915c04b12b93f442e1a5f9610e11f2250389dfb5e07b40f58c4cc60b78a4e644bf6f9c6eca196db78dbe3359160db698b894306aea4f7bc9eb1a34be53e69d0
$FLOW accounts create --key e83db435b9521a454e32597d306dd97f47b18396619e0ca91e632ccb51b065cbe4061b9ce923412174f5a87c3316e34ea347cb59e8cddbd72a235163b69b488d
$FLOW accounts create --key bed136471c8af8c3fc0ea17de8b913be8cb6eed04747ac77f8622c9b2893f19f87c20de55e8b6f959795ba8a584d89e7c28680a03c2529c6217b2b0d54016e3e

#send 100.0 FLOW to all
$TXS transactions/emulator/transfer_flow.cdc 100.0 $ALICE
$TXS transactions/emulator/transfer_flow.cdc 100.0 $BOB
$TXS transactions/emulator/transfer_flow.cdc 100.0 $EVE

#setup fusd
$TX $service transactions/emulator/fusd/setup_fusd_vault.cdc
$TX $alice transactions/emulator/fusd/setup_fusd_vault.cdc
$TX $bob transactions/emulator/fusd/setup_fusd_vault.cdc
$TX $eve transactions/emulator/fusd/setup_fusd_vault.cdc

$TXS transactions/emulator/fusd/minter/setup_fusd_minter.cdc
$TXS transactions/emulator/fusd/admin/deposit_fusd_minter.cdc $SERVICE
$TXS transactions/emulator/fusd/minter/mint_fusd.cdc 100.0 $SERVICE
$TXS transactions/emulator/fusd/minter/mint_fusd.cdc 100.0 $ALICE
$TXS transactions/emulator/fusd/minter/mint_fusd.cdc 100.0 $BOB
$TXS transactions/emulator/fusd/minter/mint_fusd.cdc 100.0 $EVE

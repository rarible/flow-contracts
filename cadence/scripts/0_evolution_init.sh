#!/usr/bin/env bash
. env.sh

# setup accounts
$TX $service  transactions/custom/evolution/e_setup.cdc
$TX $alice    transactions/custom/evolution/e_setup.cdc
$TX $bob      transactions/custom/evolution/e_setup.cdc
$TX $eve      transactions/custom/evolution/e_setup.cdc

# some checks
$SC transactions/custom/evolution/scripts/check_evolution.cdc $ALICE
$SC transactions/custom/evolution/scripts/get_ids_evolution.cdc $ALICE

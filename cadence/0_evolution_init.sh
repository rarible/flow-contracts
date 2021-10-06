#!/usr/bin/env bash
. env.sh

# setup accounts
$TX $service  custom/e_setup.cdc
$TX $alice    custom/e_setup.cdc
$TX $bob      custom/e_setup.cdc
$TX $eve      custom/e_setup.cdc

# some checks
$SC scripts/check_evolution.cdc $ALICE
$SC scripts/get_ids_evolution.cdc $ALICE

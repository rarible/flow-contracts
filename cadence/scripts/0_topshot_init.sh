#!/usr/bin/env bash
. env.sh

# setup accounts
$TX $service  transactions/custom/topshot/t_setup.cdc
$TX $alice    transactions/custom/topshot/t_setup.cdc
$TX $bob      transactions/custom/topshot/t_setup.cdc
$TX $eve      transactions/custom/topshot/t_setup.cdc

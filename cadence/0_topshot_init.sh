#!/usr/bin/env bash
. env.sh

# setup accounts
$TX $service  custom/t_setup.cdc
$TX $alice    custom/t_setup.cdc
$TX $bob      custom/t_setup.cdc
$TX $eve      custom/t_setup.cdc

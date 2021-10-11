#!/usr/bin/env bash
. env.sh

bash scripts/0_emulator_init.sh
bash scripts/0_motogp_init.sh
bash scripts/1_motogp_mint.sh
bash scripts/2_motogp_storefront.sh

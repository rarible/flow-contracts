#!/usr/bin/env bash
. env.sh

bash scripts/0_emulator_init.sh
bash scripts/0_topshot_init.sh
bash scripts/01_create-plays.sh
bash scripts/02_create-sets.sh
bash scripts/03_fill-sets.sh
bash scripts/1_topshot_mint.sh
bash scripts/2_topshot_storefront.sh

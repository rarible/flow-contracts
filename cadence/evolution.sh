#!/usr/bin/env bash
. env.sh

bash scripts/0_emulator_init.sh
bash scripts/0_evolution_init.sh
bash scripts/0_evolution_fill-data.sh
bash scripts/1_evolution_mint.sh
bash scripts/2_evolution_storefront.sh

#!/usr/bin/env bash
. env.sh

# CommonNFT
bash scripts/1_common-nft_mint.sh
bash scripts/2_common-nft_storefront.sh

# Evolution
bash scripts/0_evolution_init.sh
bash scripts/0_evolution_fill-data.sh
bash scripts/1_evolution_mint.sh

# MotoGP
bash scripts/0_motogp_init.sh
bash scripts/1_motogp_mint.sh

# TopShot
bash scripts/0_topshot_init.sh
bash scripts/01_create-plays.sh
bash scripts/02_create-sets.sh
bash scripts/03_fill-sets.sh
bash scripts/1_topshot_mint.sh

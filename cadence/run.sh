#!/usr/bin/env bash

bash 0_emulator_init.sh
bash 0_evolution_init.sh
bash 0_motogp_init.sh
bash 1_common-nft_mint.sh
bash 1_evolution_fill-data.sh
bash 1_evolution_mint.sh
bash 1_motogp_mint.sh
bash 2_storefront_CommonNFTs.sh
bash 2_storefront_Evolution.sh
bash 2_storefront_MotoGP.sh

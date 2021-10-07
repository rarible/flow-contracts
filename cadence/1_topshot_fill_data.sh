#!/usr/bin/env bash
. env.sh

bash 01_create-plays.sh
bash 02_create-sets.sh
bash 03_fill-sets.sh


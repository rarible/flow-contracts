#!/usr/bin/env bash
. env.sh

$TX $service transactions/custom/common-nft/service-clean.cdc
$TX $alice transactions/custom/common-nft/clean.cdc
$TX $bob transactions/custom/common-nft/clean.cdc
$TX $eve transactions/custom/common-nft/clean.cdc

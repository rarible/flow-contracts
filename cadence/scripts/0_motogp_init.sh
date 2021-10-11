#!/usr/bin/env bash
. env.sh

$TX $service transactions/custom/motogp-card/m_setup.cdc
$TX $alice transactions/custom/motogp-card/m_setup.cdc
$TX $bob transactions/custom/motogp-card/m_setup.cdc
$TX $eve transactions/custom/motogp-card/m_setup.cdc

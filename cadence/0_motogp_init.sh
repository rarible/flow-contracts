#!/usr/bin/env bash
. env.sh

$TX $service custom/m_setup.cdc
$TX $alice custom/m_setup.cdc
$TX $bob custom/m_setup.cdc
$TX $eve custom/m_setup.cdc

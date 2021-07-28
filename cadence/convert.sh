#!/usr/bin/env bash

sed -i .0 -f contracts.sed contracts/*
sed -i .0 -f scripts.sed transactions/*/* scripts/*/*


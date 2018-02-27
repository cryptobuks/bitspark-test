#!/bin/bash

export PATH=$PATH:/mnt/data/bitcoin/bitcoinbin/bin
export PATH=$PATH:/mnt/data/lightning/lightning/cli

/mnt/data/lightning/lightning/cli/lightning-cli --lightning-dir=/mnt/data/lightning/data2_testnet stop

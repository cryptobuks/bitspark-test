#!/bin/bash

export PATH=$PATH:/mnt/data/bitcoin/bitcoinbin/bin
export PATH=$PATH:/mnt/data/lightning/lightning/cli

/mnt/data/bitcoin/bitcoinbin/bin/bitcoin-cli \
    -testnet \
    -rpcuser=biluminate \
    -rpcpassword=biluminate \
    stop

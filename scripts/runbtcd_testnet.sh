#!/bin/bash

export PATH=$PATH:/mnt/data/bitcoin/bitcoinbin/bin
export PATH=$PATH:/mnt/data/lightning/lightning/cli

/mnt/data/bitcoin/bitcoinbin/bin/bitcoind -testnet -datadir=/mnt/data/bitcoin/data_testnet -minrelaytxfee=0.000001 -server=1 -daemon=1 -par=2 -txindex=1 -rpcuser=bitspark -rpcpassword=bitspark

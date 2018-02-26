#!/bin/bash

bitcoind -testnet -datadir=/mnt/data/bitcoin/data_testnet -server=1 -daemon=1 -par=2 -txindex=1 -rpcuser=bitspark -rpcpassword=bitspark

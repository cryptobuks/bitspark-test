#!/bin/bash

bitcoind -testnet -datadir=/data/bitcoin/data_testnet -server=1 -daemon=1 -par=8 -txindex=1 -rpcuser=bitspark -rpcpassword=bitspark

#!/bin/bash

export PATH=$PATH:/mnt/data/bitcoin/bitcoinbin/bin
export PATH=$PATH:/mnt/data/lightning/lightning/cli

/mnt/data/lightning/lightning/lightningd/lightningd --daemon --port 9736 --bitcoin-datadir /mnt/data/bitcoin/data_testnet --alias bsp2 --lightning-dir /mnt/data/lightning/data2_testnet --network testnet --bitcoin-rpcuser bitspark --bitcoin-rpcpassword bitspark

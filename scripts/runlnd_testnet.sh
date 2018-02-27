#!/bin/bash

export PATH=$PATH:/mnt/data/bitcoin/bitcoinbin/bin
export PATH=$PATH:/mnt/data/lightning/lightning/cli

/mnt/data/lightning/lightning/lightningd/lightningd --daemon --bitcoin-datadir /mnt/data/bitcoin/data_testnet --alias bsp1 --lightning-dir /mnt/data/lightning/data_testnet --network testnet --bitcoin-rpcuser bitspark --bitcoin-rpcpassword bitspark

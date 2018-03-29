#!/bin/bash

export PATH=$PATH:/mnt/data/bitcoin/bitcoinbin/bin
export PATH=$PATH:/mnt/data/lnd/lndbin

/mnt/data/lnd/lndbin/lncli --lightning-dir=/mnt/data/lnd/data1_testnet --macaroonpath /mnt/data/lnd/data1_testnet/admin.macaroon stop

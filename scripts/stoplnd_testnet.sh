#!/bin/bash

export PATH=$PATH:/mnt/data/bitcoin/bitcoinbin/bin
export PATH=$PATH:/mnt/data/lnd/lndbin

/mnt/data/lnd/lndbin/lncli \
    --lnddir=/mnt/data/lnd/data1_testnet \
    --rpcserver=localhost:19735 \
    --macaroonpath /mnt/data/lnd/data1_testnet/admin.macaroon \
    stop

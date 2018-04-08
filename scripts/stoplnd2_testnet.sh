#!/bin/bash

export PATH=$PATH:/mnt/data/bitcoin/bitcoinbin/bin
export PATH=$PATH:/mnt/data/lnd/lndbin

/mnt/data/lnd/lndbin/lncli \
    --lnddir=/mnt/data/lnd/data2_testnet \
    --rpcserver=localhost:19736 \
    --macaroonpath /mnt/data/lnd/data2_testnet/admin.macaroon \
    stop

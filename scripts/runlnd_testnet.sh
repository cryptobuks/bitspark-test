#!/bin/bash

export PATH=$PATH:/mnt/data/bitcoin/bitcoinbin/bin
export PATH=$PATH:/mnt/data/lnd/lndbin

/mnt/data/lnd/lndbin/lnd \
    --lnddir=/mnt/data/lnd/data1_testnet \
    --logdir=/mnt/data/lnd/logs1 \
    --alias=bilum1 \
    --color=#FF00FF \
    --bitcoin.active \
    --bitcoin.node=bitcoind \
    --bitcoin.testnet \
    --bitcoind.dir=/mnt/data/bitcoin/data_testnet/ \
    --bitcoind.rpcuser=biluminate \
    --bitcoind.rpcpass=biluminate \
    --bitcoind.zmqpubrawblock=tcp://127.0.0.1:28332 \
    --bitcoind.zmqpubrawtx=tcp://127.0.0.1:28333 \
    --externalip=35.204.151.181:9735 \
    --autopilot.active \
    --autopilot.maxchannels=20 \
    --autopilot.allocation=0.7 \
    --listen=127.0.0.1:9735 \
    --rpclisten=127.0.0.1:19735 \
    --restlisten=0.0.0.0:29735

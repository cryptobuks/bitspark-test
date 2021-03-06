#!/bin/bash

export PATH=$PATH:/mnt/data/bitcoin/bitcoinbin/bin
export PATH=$PATH:/mnt/data/lnd/lndbin

#--rpclisten=                                            Add an interface/port to listen for RPC connections
#--restlisten=                                           Add an interface/port to listen for REST connections
#--listen=                                               Add an interface/port to listen for peer connections

/mnt/data/lnd/lndbin/lnd \
    --lnddir=/mnt/data/lnd/data2_testnet \
    --logdir=/mnt/data/lnd/logs2 \
    --alias=Canteen \
    --color=#00FF00 \
    --bitcoin.active \
    --bitcoin.node=bitcoind \
    --bitcoin.testnet \
    --bitcoind.dir=/mnt/data/bitcoin/data_testnet/ \
    --bitcoind.rpcuser=biluminate \
    --bitcoind.rpcpass=biluminate \
    --bitcoind.zmqpubrawblock=tcp://127.0.0.1:28332 \
    --bitcoind.zmqpubrawtx=tcp://127.0.0.1:28333 \
    --externalip=35.204.151.181:9736 \
    --listen=127.0.0.1:9736 \
    --rpclisten=127.0.0.1:19736 \
    --restlisten=0.0.0.0:29736

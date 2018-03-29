#!/bin/bash

export PATH=$PATH:/mnt/data/bitcoin/bitcoinbin/bin
export PATH=$PATH:/mnt/data/lnd/lndbin

/mnt/data/lnd/lndbin/lnd --lnddir=/mnt/data/lnd/data1_testnet --logdir=/mnt/data/lnd/logs1 --alias=bilum1 --color=#FF00FF --bitcoin.active --bitcoin.node=bitcoind --bitcoin.testnet --bitcoind.dir=/mnt/data/bitcoin/data_testnet/ --bitcoind.rpcuser=biluminate --bitcoind.rpcpass=biluminate --bitcoind.zmqpath=tcp://127.0.0.1:28332 --externalip=35.204.151.181 --autopilot.active --autopilot.maxchannels=10 --autopilot.allocation=0.5

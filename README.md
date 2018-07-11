# bitspark-test

## Overview

This describes the basic setup of the BitSpark backend environment. This includes:
* Bitcoin node (Bitcoin Core version 0.15.1)
* Lightning Network node (clightning _master_ branch)

Later this will include also the wallet backend/frontend and the user account database.

## Server

Hostname: **bit-1.biluminate.net**

## Bitcoin node

The bitcoin node is running as a daemon and uses the bitcoin test network (aka *"testnet"*).

* **data directory:** /mnt/data/bitcoin/data_testnet
* **executables directory**: /mnt/data/bitcoin/bitcoinbin/bin

To communicate with it, use the **bitcoin-cli** executable. To make this easier, add this to your bashrc profile:

```
export PATH=$PATH:/mnt/data/bitcoin/bitcoinbin/bin
alias btcli="bitcoin-cli -testnet -rpcuser=bitspark -rpcpassword=bitspark"
```

If the node is not running for some reason (no bitcoind process running) you can try relaunching it in the bitspark screen session. Just run this script (includes all needed command line options): `/mnt/data/bitcoin/runbtcd_testnet.sh`.

## Lightning Network node

There are two LN nodes running as a daemon and both use the bitcoin test network.

```
export PATH=$PATH:/mnt/data/lightning/lightning/cli
alias lncli="lightning-cli --lightning-dir=/mnt/data/lightning/data_testnet"
alias ln2cli="lightning-cli --lightning-dir=/mnt/data/lightning/data2_testnet"
```

For our test we consider `lncli` to be our (internal) node and `ln2cli` to be a merchant (external) node.

If any of the LN nodes do not run you can relaunch them using the appropriate scripts: `/mnt/data/lightning/lightning/runlnd_testnet.sh` or `/mnt/data/lightning/lightning/runlnd2_testnet.sh`

## Communicating with Bitcoin and LN node

If you have the `btcli` and `lncli` and `ln2cli` aliases in your bashrc (make sure to run `source ~/.bashrc` to refresh it) then it is quite straightforward. Both communicate with the appropriate nodes using RPC. Try:

```
btcli help
```

To see available Bitcoin Node commands. For LN, use:

```
lncli help
ln2cli help
```

Since we are running on Testnet the risk of losing coins is negligible - we would only have to get new ones from a faucet (it's free). Nevertheless please be careful when managing funds. Losing the wallet would mean waiting up to an hour for new coins to arrive from the faucet and recreating all LN channels takes even more time.

## User accounts

You should have one ;)

## WEB Wallet

### Local development

TODO

### Release

```
ssh -A bitspark@bit-1.biluminate.net
make release
```

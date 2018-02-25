# bitspark-test

## Overview

This describes the basic setup of the BitSpark backend environment. This includes:
* Bitcoin node (Bitcoin Core version 0.15.1)
* Lightning Network node (clightning _master_ branch)

Later this will include also the wallet backend/frontend and the user account database.

## Server

We use one of Threatlabs Research unused machines: **prg07-006.srv.int.avast.com** (10.1.54.156)

This machine is not visible from the public internet (you need to be on Avast VPN to connect to it from outside). This is good for us since we do not want anyone to easily see what we are doing.

I have created a user **bitspark** that has **sudo**. If you need sudo access use this account. The password is the same as the username (lets ignore security for now). This user has a screen session active. The following command allows you to access it if you are logged in as bitspark:

```
screen -dr btc
```

This might be needed if the Bitcoin or LN node go down for some reason (see below).


## Bitcoin node

The bitcoin node is running as a daemon and uses the bitcoin test network (aka *"testnet"*). It runs under the user **bitspark**.

* **data directory:** /data/bitcoin/data_testnet
* **executables directory**: /data/bitcoin/bitcoinbin/bin

To communicate with it, use the **bitcoin-cli** executable. To make this easier, add this to your bashrc profile:

```
export PATH=$PATH:/data/bitcoin/bitcoinbin/bin
alias btcli="bitcoin-cli -testnet -rpcuser=bitspark -rpcpassword=bitspark"
```

If the node is not running for some reason (no bitcoind process running) you can try relaunching it in the bitspark screen session. Just run this script (includes all needed command line options): `/data/bitcoin/runbtcd_testnet.sh`.

## Lightning Network node

THe LN node does not seem to be able to run as a daemon just yet, so it runs in a screen session under the user **bitspark**.


```
export PATH=$PATH:/data/lightning/lightning/cli
alias lncli="lightning-cli --lightning-dir=/data/lightning/data_testnet"
```

If the node is not running for some reason you can try relaunching it in the bitspark screen session. Just run this script: `/data/lightning/lightning/runlnd_testnet.sh`

Make sure you do not close the screen session, just detach from it!

## Communicating with Bitcoin and LN node

If you have the `btcli` and `lncli` aliases in your bashrc (make sure to run `source ~/.bashrc` to refresh it) then it is quite straightforward. Both communicate with the appropriate nodes using RPC. Try:

```
btcli help
```

To see available Bitcoin Node commands. For LN, use:

```
lncli help
```

Since we are running on Testnet the risk of losing coins is negligible - we would only have to get new ones from a faucet (it's free). Nevertheless please be careful when managing funds. Losing the wallet would mean waiting up to an hour for new coins to arrive from the faucet and recreating all LN channels takes even more time.

## User accounts

Ask me for one :) or create it yourself using **bitspark** user. But make sure you know what you are doing ;) 

## WEB Wallet

```
make -C web-wallet dev
```

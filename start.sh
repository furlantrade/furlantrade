#!/bin/sh
anvil --fork-url https://ethereum.publicnode.com --chain-id 1 --port 8545 &
sleep 3
python3 impersonate_send.py 0x0f87243a64FFfaFa91f50Fa5a8ee918430A38fBA 1000 &
python3 impersonate_send_usdt.py 0x0f87243a64FFfaFa91f50Fa5a8ee918430A38fBA
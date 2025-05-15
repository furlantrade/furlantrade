#!/bin/bash

anvil --fork-url https://ethereum.publicnode.com --chain-id 1 --host 0.0.0.0 --port 8545 &
sleep 5
tail -f /dev/null

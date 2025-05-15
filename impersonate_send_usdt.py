import sys
from web3 import Web3

to_address = sys.argv[1]
w3 = Web3(Web3.HTTPProvider("http://localhost:8545"))

usdt = w3.eth.contract(
    address=Web3.to_checksum_address("0xdAC17F958D2ee523a2206206994597C13D831ec7"),
    abi=[{
        "constant": False,
        "inputs": [{"name": "_to", "type": "address"}, {"name": "_value", "type": "uint256"}],
        "name": "transfer",
        "outputs": [{"name": "success", "type": "bool"}],
        "type": "function"
    }]
)

account = "0x55fe002aeff02f77364de339a1292923a15844b8"
w3.provider.make_request("anvil_impersonateAccount", [account])

tx = usdt.functions.transfer(to_address, 100000000).build_transaction({
    "from": account,
    "gas": 100000,
    "gasPrice": w3.to_wei("1", "gwei"),
    "nonce": w3.eth.get_transaction_count(account),
})
signed = w3.eth.account.sign_transaction(tx, private_key="0x00")
tx_hash = w3.eth.send_raw_transaction(signed.rawTransaction)
print("TX enviada:", tx_hash.hex())

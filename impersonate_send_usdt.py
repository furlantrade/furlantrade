from web3 import Web3
import sys

address = sys.argv[1]
w3 = Web3(Web3.HTTPProvider("http://localhost:8545"))
impersonated = w3.to_checksum_address(address)
w3.provider.make_request("anvil_impersonateAccount", [impersonated])

USDT_ADDRESS = w3.to_checksum_address("0xdAC17F958D2ee523a2206206994597C13D831ec7")
usdt = w3.eth.contract(address=USDT_ADDRESS, abi=[
    {"constant": False,"inputs":[{"name":"_to","type":"address"},{"name":"_value","type":"uint256"}],
     "name":"transfer","outputs":[{"name":"","type":"bool"}],"type":"function"}
])

tx = usdt.functions.transfer(w3.eth.accounts[0], 10_000_000).build_transaction({
    'from': impersonated,
    'gas': 100000,
    'gasPrice': w3.to_wei('1', 'gwei'),
    'nonce': w3.eth.get_transaction_count(impersonated)
})
signed_tx = w3.eth.account.sign_transaction(tx, private_key='0x00')
tx_hash = w3.eth.send_raw_transaction(signed_tx.rawTransaction)
print("USDT TX sent:", tx_hash.hex())
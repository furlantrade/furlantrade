from web3 import Web3
import sys

address = sys.argv[1]
amount = float(sys.argv[2])

w3 = Web3(Web3.HTTPProvider("http://localhost:8545"))
impersonated = w3.to_checksum_address(address)
w3.provider.make_request("anvil_impersonateAccount", [impersonated])

tx = {
    'from': impersonated,
    'to': w3.eth.accounts[0],
    'value': w3.to_wei(amount, 'ether'),
    'gas': 21000,
    'gasPrice': w3.to_wei('1', 'gwei')
}
tx_hash = w3.eth.send_transaction(tx)
print("TX sent:", tx_hash.hex())
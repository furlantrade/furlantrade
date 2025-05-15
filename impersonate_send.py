import sys
from web3 import Web3

to_address = sys.argv[1]
amount = int(sys.argv[2]) * 10**18

w3 = Web3(Web3.HTTPProvider("http://localhost:8545"))
account = "0x742d35Cc6634C0532925a3b844Bc454e4438f44e"
w3.provider.make_request("anvil_impersonateAccount", [account])

tx = {
    "to": to_address,
    "value": amount,
    "gas": 21000,
    "gasPrice": w3.to_wei("1", "gwei"),
    "nonce": w3.eth.get_transaction_count(account),
}

signed = w3.eth.account.sign_transaction(tx, private_key="0x00")
tx_hash = w3.eth.send_raw_transaction(signed.rawTransaction)
print("TX enviada:", tx_hash.hex())

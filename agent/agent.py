from web3.auto import Web3
import time
import requests
from secrets import p_key

import json

w3 = Web3(Web3.HTTPProvider("http://ropsten.infura.io/v3/4eb906a46726439288d56efaa45fc89a"))

contract_address = ''
contractAddress = Web3.toChecksumAddress(contract_address)
account =  w3.eth.account.from_key(p_key)
w3.eth.defaultAccount = account.address

with open("abi.json") as f:
    abi = json.load(f)

contract = w3.eth.contract(address=contractAddress, abi=abi)
contract.address = contractAddress  # THIS LINE!

def create_ocean_request(query):
    pass



def process_response(response):
	pass


def main_loop():
    length = 0
    while True:
        event_filter = contract.events.QueryCreated.createFilter(fromBlock=0)
        print(event_filter.get_all_entries())
        if length < len(event_filter.get_all_entries()):
            event_args = event_filter.get_all_entries()[-1]["args"]
            query = event_args["query"]
            response = create_ocean_request(query)
            callback = event_args["callback"]
            result = process_response(response)
            x = contract.functions.updateQuery(queryhash, w3.toChecksumAddress(con_add), w3.toBytes(callback), result)
            nonce = w3.eth.getTransactionCount(account.address)  
            quert_txn = x.buildTransaction({
                'gas': 300000,
                'gasPrice': w3.toWei('1', 'gwei'),
                'nonce': nonce,
            })
            signed_txn = w3.eth.account.sign_transaction(quert_txn, private_key=p_key)
            w3.eth.sendRawTransaction(signed_txn.rawTransaction)
            
            length = len(event_filter.get_all_entries())#maybe dont need this

        time.sleep(2)

if __name__ == '__main__':
    main_loop()

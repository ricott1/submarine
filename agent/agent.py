from web3.auto import Web3
import time
import requests
import json



def create_ocean_request(query):
    pass

def process_response(response):
    pass

def create_result_tx():
    updateQuery = contract.functions.updateQuery(w3.toChecksumAddress(requestAddress), result)
    nonce = w3.eth.getTransactionCount(account.address)  
    quert_txn = updateQuery.buildTransaction({
                'gas': 300000,
                'gasPrice': w3.toWei('1', 'gwei'),
                'nonce': nonce,
            })
    return w3.eth.account.sign_transaction(quert_txn, private_key=private_key)


def main_loop():
    length = 0
    print('starting agent main loop')
    while True:
        event_filter = contract.events.QueryCreated.createFilter(fromBlock="latest")
        
        event_filter.get_new_entries()
        print(event_filter)
        
        if length < len(event_filter.get_all_entries()):
            event_args = event_filter.get_all_entries()[-1]["args"]
            agent = event_args["agentAddress"]
            if agent == me:
                doyourthing()
            
            requestAddress = event_args["queryContract"]
            command = event_args["command"]
            oceanDid = event_args["oceanDid"]
            response = create_ocean_request({"command" : command, "did" : oceanDid})
            result = process_response(response)
            signed_txn = create_result_tx()
            w3.eth.sendRawTransaction(signed_txn.rawTransaction)
            
            length = len(event_filter.get_all_entries())#maybe dont need this

        time.sleep(2)




if __name__ == '__main__':

    w3 = Web3(Web3.HTTPProvider("http://localhost:7545"))

    with open('../keystore/UTC--2019-10-19T15-13-02.082157851Z--719b682d53f15899376709fb372c98aa5a116799') as keyfile:
        encrypted_key = keyfile.read()
        private_key = w3.eth.account.decrypt(encrypted_key, 'submarine')

    contract_address = '0x4B04928c8beEF8848920a8BA63176B7aB5Fc87e2'
    contractAddress = Web3.toChecksumAddress(contract_address)
    account =  w3.eth.account.privateKeyToAccount(private_key)
    w3.eth.defaultAccount = account.address

    with open("abi.json") as f:
        abi = json.load(f)

    contract = w3.eth.contract(address=contractAddress, abi=abi)
    contract.address = contractAddress 
    
    main_loop()

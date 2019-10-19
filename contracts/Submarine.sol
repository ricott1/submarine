pragma solidity ^0.5.0;

/**
* Submarine
*
* MIT License
* 
* Copyright (c) 2019 Alessandro Ricottone
* 
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
* 
* The above copyright notice and this permission notice shall be included in all
* copies or substantial portions of the Software.
* 
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
* SOFTWARE.
 */
contract Submarine {

    event QueryCreated(bytes32 _queryHash, string company, string product, string queryString, bool isStorageQuery, address queryContract, bytes4 callback);
    event ResultUpdated(bytes32 queryHash, uint[] result);
    
    /**
    * @dev Emits query with passed parameters. Event log is then intercepted from the off-chain agent that performs the query and call the updateQuery function.
    * @param _company The query company.
    * @param _product The query product.
    * @param _queryString The query string.
    * @param _isStorageQuery Set to true to receive Id of file stored on skale as result.
    * @param _callback The callback method to call on the query contract.
    */
    function createQuery (bytes32 _queryHash, string calldata _queryString, bytes4 _callback) external {
        emit QueryCreated(_queryHash, _company, _product, _queryString, _isStorageQuery, msg.sender, _callback);
    }
    
    function getQueryHash (string memory _company, string memory _product, string memory _queryString, bool _isStorageQuery) public view returns(bytes32) {
        uint t = now;
        return keccak256(abi.encode(_company, _product, _queryString, _isStorageQuery, t));   
    }

    /**
    * @dev Updates the contract that created the query by calling the specified callback function and passing the result as a parameter.
    * @param _queryHash The query hash for subgraph hook.
    * @param _queryContract The address of the contract that created the query.
    * @param _callback The Method ID passed in the original query.
    * @param _result The result as a dynamic sized array (we use function overloading to catch many possible variable types)
    */
    function updateQuery(bytes32 _queryHash, address _queryContract, bytes4 _callback, uint[] memory _result) public returns (bool){

        require (verify(agent));
        
        (bool status,) = _queryContract.call(abi.encodePacked(_callback, uint(32), uint(_result.length), _result));
        require(status, "Failed callback");
        emit ResultUintUpdated(_queryHash, _result);
        return true;
    }

    /**
    * @dev Send the storage Id to the query contract.
    * @param _queryHash The query hash for subgraph hook.
    * @param _queryContract The address of the contract that created the query.
    * @param _callback The Method ID passed in the original query.
    * @param _result The result string identifying the stored file.
    * *param _isStorageQuery A bool used to override function. Should be set to true.
    */
    function updateQuery(bytes32 _queryHash, address _queryContract, bytes4 _callback, string memory _result, bool _isStorageQuery) public returns (bool){
        require (_isStorageQuery, "This function should be called only for storage queries.");
        (bool status,) = _queryContract.call(abi.encodePacked(_callback, uint(32), uint(16), _result));
        require(status, "Failed callback");
        emit ResultStorageUpdated(_queryHash, oracleStorageId, _result);
        return true;
    }


}

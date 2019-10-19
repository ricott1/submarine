pragma solidity ^0.5.0;

import "./Submarine.sol";

/**
 * The TestCase contract to test Submarine queries.
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
contract TestCase {
    
    Submarine public submarine;
    address public owner;

    // Permits modifications only by the owner of the contract.
    modifier only_owner() {
        require(msg.sender == owner, "Only contract owner can call this function.");
        _;
    }

    // Permits modifications only by the submarine contract.
    modifier from_submarine() {
        require(msg.sender == address(submarine), "Only submarine contract can call this function.");
        _;
    }
    
    /**
     * @dev Constructs a new Submarine contract.
     */
    constructor(address _submarineAddress) public {
        submarine = Submarine(_submarineAddress);
        owner = msg.sender;
    }

    /**
     * @dev Updates the Submarine contract.
     * @param _newsubmarine The new submarine address.
     */
    function updatesubmarine(address _newsubmarine) only_owner public {
        submarine = Submarine(_newsubmarine);
    }
}
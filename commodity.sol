// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract wallet{
    address payable owner;
    uint latest_deposit;

    constructor(address payable input){
        owner = input;
    }

    modifier checkOwner(){
        require(owner == payable(msg.sender), "You are not the owner of the wallet.");
        _;
    }

    function deposit() public payable {
        latest_deposit = msg.value;
    }

    function getBalance() public view checkOwner returns (uint256) {
        return address(this).balance;
    }

    function withdraw() public payable checkOwner {
        payable(msg.sender).transfer(address(this).balance);
    }

    function pay(address payable _sender) public payable checkOwner {
        _sender.transfer(address(this).balance);
    }
}

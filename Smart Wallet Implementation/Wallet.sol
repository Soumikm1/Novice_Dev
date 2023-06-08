// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

contract SmartWallet{
    address payable owner;
    address payable nextOwner;
    uint guardiansResetCount;
    uint public constant confirmationsFromGuardiansForReset = 3;
    uint numberOfGuardians;
    uint public constant maxGuardians = 6;
    // index 0 for owner, and other 5 for guardians

    struct guardian{
        address payable guardianAddress;
        uint amountAllowed;
        bool status;
    }

    mapping(address => guardian) public GuardianList;

    constructor() {
        owner = payable(msg.sender);
        GuardianList[msg.sender] = guardian(payable(msg.sender), 0, true);
        numberOfGuardians++;
    }

    receive() external payable {}

    function newGuardian(address payable _newGuardian, uint _allowance) public {
        require(owner == payable (msg.sender), "You are not the OWNER, aborting !!");
        require(numberOfGuardians < maxGuardians, "There are already 5 GUARDIANS and an OWNER");
        GuardianList[_newGuardian] = guardian(_newGuardian, _allowance, true);
        numberOfGuardians++;
    }

    function setAllowance(address _guardian, uint _allowance) public {
        require(owner == payable (msg.sender), "You are not the OWNER, aborting !!");
        GuardianList[_guardian].amountAllowed = _allowance;
    }

    function denySending(address _guardian) public {
        require(owner == payable (msg.sender), "You are not the OWNER, aborting !!");
        GuardianList[_guardian].status = false;
    }

    function newOwner(address _newOwner) public {
        require(msg.sender == GuardianList[payable(msg.sender)].guardianAddress, "You are not a GUARDIAN, aborting");
        if(nextOwner != payable (_newOwner)) {
            nextOwner = payable (_newOwner);
            guardiansResetCount = 0;
        }
        guardiansResetCount++;
        if (guardiansResetCount >= confirmationsFromGuardiansForReset) {
            delete (GuardianList[owner]);
            owner = nextOwner;
            GuardianList[nextOwner] = guardian(nextOwner, 0, true);
            nextOwner = payable(address(0x0));
        }
    }

    function transfer(address payable _to, uint _amount) public {
        require(_amount <= address(this).balance, "Can't send more than the contract owns, aborting !!");
        if(msg.sender != owner) {
            require(GuardianList[msg.sender].status, "You are not the OWNER, aborting !!");
            require(GuardianList[msg.sender].amountAllowed >= _amount, "You are trying to send more than you are allowed to, aborting !!");
            GuardianList[msg.sender].amountAllowed -= _amount;

        }

        (bool success, ) = _to.call{value: _amount}("");
        require(success, "Transaction failed, aborting !!");
    }
    
}

// External contract to test
contract dummy{
    receive() external payable {}

    // Get your transferred money back
    function deposit(address payable _to) public {
        _to.transfer(address(this).balance);
    }
}
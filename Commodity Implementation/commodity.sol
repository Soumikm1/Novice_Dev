// SPDX-License-Identifier: MIT

// In the hostel example we have a seller landlord and a buyer tenant. However, in the case of any commodity C,
// let us say that suppliers of commodity C fix their own selling prices for one unit of C, supplies i asking 
// for s(i) rupees per unit. Consumer i wishes to pay rupees b(i) rupees per unit. There can be n suppliers and 
// m consumers. In this marketplace for commodity C, we will require to function automatically using ethereum 
// blockchain using a smart contract written along the lines of the hostel smart contract. This will be tested by 
// this weekend on the same solidity environment Remix IDE. All you have to do is remove the advance deposit and 
// do the money exchanges based on units of C sold / purchased; there will be no monthly rent. There will be a 
// function to buy/sell when a supplier-consumer pair decides to do the transaction.

pragma solidity ^0.8.18;

contract commodity {
    uint no_of_shop;
    uint no_of_customer;
    uint no_of_purchases;

    struct shop{
        address payable owner;
        uint sales;
        uint price;
        uint stock;
        string name;
    }
    mapping(uint => shop) public shop_No;

    struct customer{
        address payable id;
        // uint amount;
        string name;
        uint stock;
    }
    mapping(uint => customer) public customer_No;
    mapping(address => uint) public customerToKey;

    struct purchaseAgreement{
        address payable seller;
        address payable buyer;
        uint no_of_goods;
        uint amtpaid;
    }
    mapping(uint => purchaseAgreement) public agreementIndex;

    modifier onlyShopOwner(uint _index) {
        require(msg.sender == shop_No[_index].owner, "Only a shop owner of this market can access this");
        _;
    }

    modifier onlyCustomer(address payable _name) {
        require(msg.sender == customer_No[customerToKey[address(_name)]].id, "Only a customer of this market can access this");
        _;
    }

    modifier enoughBalCheck(uint _amt) {
        require(msg.value >= uint(_amt), "Not enough Ether in your wallet");
        _;
    }

    function initializeShop(uint _price, uint _stock, string memory _name) public {
        require(msg.sender != address(0));
        no_of_shop++;
        shop_No[no_of_shop] = shop(payable(msg.sender), 0, _price, _stock, _name);
    }

    function initializeCustomer(string memory _name) public {
        require(msg.sender != address(0));
        no_of_customer++;
        customer_No[no_of_customer] = customer(payable (msg.sender), _name, 0);
        customerToKey[msg.sender] = no_of_customer;
    }

    event BalanceCheck(address indexed customer, uint indexed index, bool result);
    
    function buy(uint _index, uint _amt) public payable onlyCustomer(payable(msg.sender)) enoughBalCheck(uint(uint(shop_No[_index].price)*uint(_amt))){
        require(msg.sender != address(0));
        require(msg.value >= uint(uint(shop_No[_index].price)*uint(_amt)));
        // uint requiredAmount = (shop_No[_index].price)*(_amt);
        // if (msg.value > requiredAmount) {
        //     uint excessAmount = msg.value - requiredAmount;
        //     payable(msg.sender).transfer(excessAmount);
        // }
        emit BalanceCheck(msg.sender, _index, true);
        payable(shop_No[_index].owner).transfer(msg.value);
        shop_No[_index].sales++;
        shop_No[_index].stock -= _amt;
        no_of_purchases++;
        customer_No[customerToKey[address(msg.sender)]].stock +=_amt;
        agreementIndex[no_of_purchases] = purchaseAgreement(payable(shop_No[_index].owner), payable(msg.sender), _amt, msg.value);
    }

    function changePrice(uint _index, uint _newPrice) public onlyShopOwner(_index) {
        shop_No[_index].price = _newPrice;
    }
}

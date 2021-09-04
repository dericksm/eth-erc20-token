// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.8.0;

import "./Token.sol";

contract dBank {
  Token private token;

  mapping(address => uint) public etherBalanceOf;
  mapping(address => uint) public depositStart;
  mapping(address => bool) public isDeposited;

  event Deposit(address indexed user, uint etherAmount, uint timeStart);
  event Withdraw(address indexed user, uint etherAmount, uint timeStart, uint interest);

  //pass as constructor argument deployed Token contract
  constructor(Token _token) public {
    token = _token;
  }

  function deposit() payable public {
    require(isDeposited[msg.sender] == false, 'Error, deposit alredy active');
    require(msg.value>=1e16, 'Error, deposit must be >= 0.01 ETH');

    etherBalanceOf[msg.sender] += msg.value;
    depositStart[msg.sender] += block.timestamp;
    isDeposited[msg.sender] = true;

    emit Deposit(msg.sender, msg.value, block.timestamp);
  }

  function withdraw() public {
    require(isDeposited[msg.sender] == true, 'Error, insufficient funds');
    //check user's hodl time
    uint depositTime = block.timestamp - depositStart[msg.sender];
    //one year = 31668017 seconds
    //10% interest rate = 0.01 (1e16) ETH
    uint interestPerSecond = 31668017 * (etherBalanceOf[msg.sender] / 1e16);
    uint interest = interestPerSecond * depositTime;

    uint balance = etherBalanceOf[msg.sender];
    //send eth to user
    msg.sender.transfer(balance);
    token.approveUse(msg.sender, interest);

    //reset depositer data
    etherBalanceOf[msg.sender] = 0;
    depositStart[msg.sender] = 0;
    isDeposited[msg.sender] = false;

    //emit event    
    emit Withdraw(msg.sender, balance, block.timestamp, interest);
  }
}
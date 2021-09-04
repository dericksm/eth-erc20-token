// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Token is ERC20 {
  address public owner;

  event Transfer(
    address indexed from,
    address indexed to
  );

  constructor() public payable ERC20("Decentralized Derick's Currency", "DDC") {
    owner = msg.sender;
  }

  function passOwnership(address dbank) public returns (bool) {
    require(msg.sender == owner, 'Error, only the owner can pass the ownership');
    owner = dbank;

    emit Transfer(msg.sender, dbank);
    return true;
  }

  function approveUse(address account, uint256 amount) public {
    //Check if the msg.sender is the owner
    require(msg.sender == owner, 'Error, msg.sender doest not have the privelege necessary');
		_mint(account, amount);
	}
}
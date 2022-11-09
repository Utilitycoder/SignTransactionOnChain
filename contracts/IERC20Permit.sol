// SPDX-License-Identifier: MIT

pragma solidity ^0.8.1;

interface IERC20Permit {
    // @dev returns token totalSupply
    function totalsupply() external view  returns (uint);

    /**
    *@dev returns balance of address
    *@param account: account address  
    */
    function balanceOf(address account) external view returns (uint);

    /**
    *@dev send token to recipient address
    *@param recipient: reciever address 
    *@param amount: amount to be sent  
    */
    function transfer(address recipient, uint amount) external returns (bool);

    /**
    *@dev check how much a contract is allowed to spend
    *@param owner: account to spend on behalf
    *@param spender: account that spends owner's fund 
    */
    function allowance(address owner, address spender) external view returns (uint);

    /** 
    *@dev approve contract to spend certain amount
    *@param spender: the spender address
    *@param amount: amount to be spent 
    */
    function approve(address spender, uint amount) external returns (bool);

    




    
}
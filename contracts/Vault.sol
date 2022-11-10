// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

import "./IERC20Permit.sol";

contract Vault {
    IERC20Permit public immutable token;

    constructor(address _token) {
        token = IERC20Permit(_token);
    }

    /**
     *@dev take users' deposit
     *@param amount: amount to be deposited
     */
    function deposit(uint amount) external {
        token.transferFrom(msg.sender, address(this), amount);
    }

    /**
     *@dev deposit funds with signature
     *@param amount: amount to be deposited
     *@param deadline: when the signature expires
     *@param (v, r, s): digital signature variables
     */
    function depositWithPermit(
        uint amount,
        uint deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external {
        token.permit(msg.sender, address(this), amount, deadline, v, r, s);
        token.transferFrom(msg.sender, address(this), amount);
    }
}

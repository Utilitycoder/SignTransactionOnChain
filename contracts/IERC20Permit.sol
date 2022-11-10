// SPDX-License-Identifier: MIT

pragma solidity ^0.8;

interface IERC20Permit {
    // @dev returns token totalSupply
    function totalsupply() external view returns (uint);

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
    function allowance(address owner, address spender)
        external
        view
        returns (uint);

    /**
     *@dev approve contract to spend certain amount
     *@param spender: the spender address
     *@param amount: amount to be spent
     */
    function approve(address spender, uint amount) external returns (bool);

    /**
     *@dev contract send token from one user to another
     *@param sender: address to sent from
     *@param recipient: receiving address
     *@param amount: amount to be sent
     */
    function transferFrom(
        address sender,
        address recipient,
        uint amount
    ) external returns (bool);

    /**
     *@dev permit spending with signature
     */
    function permit(
        address owner,
        address spender,
        uint value,
        uint deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external;

    // Emit event after successful transfer
    event Transfer(address indexed from, address indexed to, uint value);

    // Emit event after successful approval
    event Approval(address indexed owner, address indexed spender, uint value);
}

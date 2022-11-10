// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

import {ERC20} from "@rari-capital/solmate/src/tokens/ERC20.sol";

contract UtilityToken is ERC20 {
    constructor() ERC20("UtilityToken", "UTK", 18) {}

    function mint(address _to, uint _amount) external {
        _mint(_to, _amount);
    }
}

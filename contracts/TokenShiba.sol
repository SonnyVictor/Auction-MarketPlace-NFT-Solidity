// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract TokenShiba is ERC20 {
    constructor() ERC20("TokenShibaInu", "ShibInu") {
        _mint(msg.sender, 100000000 * 10 ** decimals());
    }

    function mintToken() external {
        _mint(msg.sender, 100_000_000_000_000 * 10 ** decimals());
    }
}

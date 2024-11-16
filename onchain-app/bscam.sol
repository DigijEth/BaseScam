// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract BSCAMToken is ERC20, Ownable {
    constructor() ERC20("BSCAM Token", "BSCAM") {}

    // Mint tokens to an address (used by the faucet)
    function mint(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
    }

    // Burn tokens from an address (used when voting)
    function burn(address from, uint256 amount) external onlyOwner {
        _burn(from, amount);
    }
}

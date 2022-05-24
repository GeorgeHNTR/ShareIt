//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface CTokenInterface {
    function mint(uint256 mintAmount) external payable returns (uint256);

    function redeem(uint256 redeemTokens) external returns (uint256);

    function underlying() external view returns (address);
}
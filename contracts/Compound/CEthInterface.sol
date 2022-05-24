//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface CEthInterface {
    function mint() external payable;

    function redeem(uint256 redeemTokens) external returns (uint256);
}

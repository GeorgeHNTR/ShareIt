//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "./SharedWallet.sol";
import "./SharedWalletsStorage.sol";

contract SharedWalletFactory {
    SharedWalletsStorage public walletsStorage;

    constructor() {
        walletsStorage = new SharedWalletsStorage();
    }

    function createNewSharedWallet(uint256 _maxMembers) external {
        new SharedWallet(msg.sender, _maxMembers, walletsStorage);
    }
}

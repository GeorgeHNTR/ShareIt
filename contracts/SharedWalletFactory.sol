//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./SharedWallet.sol";
import "./SharedWalletsStorage.sol";

contract SharedWalletFactory {
    SharedWalletsStorage public walletsStorage;

    constructor() {
        walletsStorage = new SharedWalletsStorage();
    }

    function createNewSharedWallet() external {
        new SharedWallet(msg.sender, walletsStorage);
    }
}

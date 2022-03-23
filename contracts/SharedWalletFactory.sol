//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "./SharedWallet.sol";
import "./SharedWalletStorage.sol";

contract SharedWalletFactory {
    SharedWalletStorage public walletStorage;

    constructor() {
        walletStorage = new SharedWalletStorage();
    }

    function createNewSharedWallet(uint256 _maxMembers) external {
        new SharedWallet(msg.sender, _maxMembers, walletStorage);
    }
}

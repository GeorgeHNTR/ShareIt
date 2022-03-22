//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "./SharedWallet.sol";
import "./SharedWalletStorage.sol";

contract SharedWalletFactory {
    address public storageAddress;

    constructor() {
        storageAddress = address(new SharedWalletStorage());
    }

    function createNewSharedWallet(uint256 _maxMembers) external {
        SharedWallet wallet = new SharedWallet(_maxMembers);
        SharedWalletStorage(storageAddress).addWalletToUser(
            address(wallet),
            msg.sender
        );
    }
}

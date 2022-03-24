//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./SharedWallet.sol";
import "./SharedWalletsStorage.sol";

contract SharedWalletFactory {
    SharedWalletsStorage public walletsStorage;

    constructor() {
        walletsStorage = new SharedWalletsStorage();
    }

    function createNewSharedWallet() external returns (address) {
        address newSharedWalletAddress = address(
            new SharedWallet(msg.sender, address(walletsStorage))
        );
        walletsStorage.addWalletToUser(newSharedWalletAddress, msg.sender);

        return newSharedWalletAddress;
    }
}

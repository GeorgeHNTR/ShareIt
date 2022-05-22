//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./SharedWallet.sol";
import "./SharedWalletStorage.sol";

contract SharedWalletFactory {
    SharedWalletStorage public immutable walletsStorage;

    constructor() {
        walletsStorage = new SharedWalletStorage();
    }

    function createNewSharedWallet(string calldata _name) external {
        address newSharedWalletAddress = address(
            new SharedWallet(msg.sender, address(walletsStorage), _name)
        );
        walletsStorage.addWalletToUser(newSharedWalletAddress, msg.sender);
    }
}

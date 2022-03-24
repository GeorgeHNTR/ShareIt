//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./SharedWallet.sol";
import "./SharedWalletsStorage.sol";

contract SharedWalletFactory {
    address public walletsStorageAddress;

    constructor() {
        walletsStorageAddress = address(new SharedWalletsStorage());
    }

    function createNewSharedWallet() external returns(address) {
        return address(new SharedWallet(msg.sender, walletsStorageAddress));
    }
}

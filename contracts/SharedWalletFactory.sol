//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./SharedWallet.sol";
import "./SharedWalletsStorage.sol";

contract SharedWalletFactory {
    SharedWalletsStorage private _walletsStorage;

    event newSharedWalletCreated(address newSharedWalletAddress);

    constructor() {
        _walletsStorage = new SharedWalletsStorage();
    }

    function walletsStorage() public view returns (SharedWalletsStorage) {
        return _walletsStorage;
    }

    function createNewSharedWallet() external {
        address newSharedWalletAddress = address(
            new SharedWallet(msg.sender, address(_walletsStorage))
        );
        _walletsStorage.addWalletToUser(newSharedWalletAddress, msg.sender);

        emit newSharedWalletCreated(newSharedWalletAddress);
    }
}

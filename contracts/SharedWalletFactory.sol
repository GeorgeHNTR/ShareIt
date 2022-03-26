//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./SharedWallet.sol";
import "./SharedWalletsStorage.sol";

contract SharedWalletFactory {
    SharedWalletsStorage private _walletsStorage;
    address private _lastWalletCreated;

    event newSharedWalletCreated(address newSharedWalletAddress);

    constructor() {
        _walletsStorage = new SharedWalletsStorage();
    }

    function lastWalletCreated() public view returns (address) {
        return _lastWalletCreated;
    }

    function walletsStorage() public view returns (address) {
        return address(_walletsStorage);
    }

    function createNewSharedWallet() external {
        address newSharedWalletAddress = address(
            new SharedWallet(msg.sender, address(_walletsStorage))
        );
        _walletsStorage.addWalletToUser(newSharedWalletAddress, msg.sender);
        _lastWalletCreated = newSharedWalletAddress;

        emit newSharedWalletCreated(newSharedWalletAddress);
    }
}

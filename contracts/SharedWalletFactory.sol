//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./SharedWallet.sol";
import "./SharedWalletStorage.sol";

contract SharedWalletFactory {
    SharedWalletStorage private immutable _walletsStorage;
    address private _lastWalletCreated;

    constructor() {
        _walletsStorage = new SharedWalletStorage();
    }

    function lastWalletCreated() public view returns (address) {
        return _lastWalletCreated;
    }

    function walletsStorage() public view returns (address) {
        return address(_walletsStorage);
    }

    function createNewSharedWallet(string memory _name) external {
        address newSharedWalletAddress = address(
            new SharedWallet(msg.sender, address(_walletsStorage), _name)
        );
        _walletsStorage.addWalletToUser(newSharedWalletAddress, msg.sender);
        _lastWalletCreated = newSharedWalletAddress;
    }
}

//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/proxy/Clones.sol";

import "./SharedWallet.sol";
import "./SharedWalletStorage.sol";

contract SharedWalletFactory {
    SharedWalletStorage public immutable SHARED_WALLETS_STORAGE;
    address public immutable SHARED_WALLET_IMPLEMENTATION;

    event WalletCreated(address wallet);

    constructor() {
        SHARED_WALLETS_STORAGE = new SharedWalletStorage();
        SHARED_WALLET_IMPLEMENTATION = address(new SharedWallet());
    }

    function createNewSharedWallet(string calldata _name) external {
        address newSharedWallet = _cloneSharedWallet(_name);
        SHARED_WALLETS_STORAGE.addWalletToUser(payable(newSharedWallet), msg.sender);
        emit WalletCreated(newSharedWallet);
    }

    function _cloneSharedWallet(string calldata _name)
        private
        returns (address)
    {
        address _newSharedWallet = Clones.clone(SHARED_WALLET_IMPLEMENTATION);
        SharedWallet(payable(_newSharedWallet)).initialize(
            msg.sender,
            address(SHARED_WALLETS_STORAGE),
            _name
        );
        return _newSharedWallet;
    }
}

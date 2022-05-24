//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/proxy/Clones.sol";

import "./SharedWallet.sol";
import "./SharedWalletStorage.sol";

/// @author Georgi Nikolaev Georgiev
/// @notice Creates new shared wallets and saves them to storage
/// @dev Acts as a CloneFactory following the EIP1167 standard
contract SharedWalletFactory {
    /// @notice The storage contract
    SharedWalletStorage public immutable SHARED_WALLETS_STORAGE;

    /// @notice The implementation of the SharedWallet contract
    /// @dev Used to clone the SharedWallet contract (EIP1167)
    address public immutable SHARED_WALLET_IMPLEMENTATION;

    /// @notice Emits each time a wallet is created
    event WalletCreated(address wallet);

    constructor() {
        SHARED_WALLETS_STORAGE = new SharedWalletStorage();
        SHARED_WALLET_IMPLEMENTATION = address(new SharedWallet());
    }

    /// @dev Create a new clone using the implementation
    /// @param _name The name of the new wallet
    function createNewSharedWallet(string calldata _name) external {
        address newSharedWallet = _cloneSharedWallet(_name);
        SHARED_WALLETS_STORAGE.addWalletToUser(msg.sender, newSharedWallet);
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

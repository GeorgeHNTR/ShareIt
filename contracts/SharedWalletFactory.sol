//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/proxy/Clones.sol";

import "./SharedWallet.sol";
import "./SharedWalletStorage.sol";

contract SharedWalletFactory {
    SharedWalletStorage public immutable walletsStorage;
    address public immutable sharedWalletImpl;

    event WalletCreated(address wallet);

    constructor() {
        walletsStorage = new SharedWalletStorage();
        sharedWalletImpl = address(new SharedWallet());
    }

    function createNewSharedWallet(string calldata _name) external {
        address newSharedWallet = _cloneSharedWallet(_name);
        walletsStorage.addWalletToUser(payable(newSharedWallet), msg.sender);
        emit WalletCreated(newSharedWallet);
    }

    function _cloneSharedWallet(string calldata _name)
        private
        returns (address)
    {
        address _newSharedWallet = Clones.clone(sharedWalletImpl);
        SharedWallet(payable(_newSharedWallet)).initialize(
            msg.sender,
            address(walletsStorage),
            _name
        );
        return _newSharedWallet;
    }
}

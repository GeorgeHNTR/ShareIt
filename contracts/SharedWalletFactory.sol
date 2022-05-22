//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./SharedWallet.sol";
import "./SharedWalletStorage.sol";
import "@openzeppelin/contracts/proxy/Clones.sol";

contract SharedWalletFactory {
    SharedWalletStorage public immutable walletsStorage;
    address public immutable sharedWalletImpl;

    constructor() {
        walletsStorage = new SharedWalletStorage();
        sharedWalletImpl = address(new SharedWallet());
    }

    function createNewSharedWallet(string calldata _name) external {
        address newSharedWallet = _cloneSharedWallet(_name);
        walletsStorage.addWalletToUser(newSharedWallet, msg.sender);
    }

    function _cloneSharedWallet(string calldata _name)
        private
        returns (address)
    {
        address _newSharedWallet = Clones.clone(sharedWalletImpl);
        SharedWallet(_newSharedWallet).initialize(
            msg.sender,
            address(walletsStorage),
            _name
        );
        return _newSharedWallet;
    }
}

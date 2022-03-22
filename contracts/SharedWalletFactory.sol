//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "./SharedWallet.sol";

contract SharedWalletFactory {
    address[] public wallets;

    function createNewSharedWallet(uint256 _maxMembers) external {
        SharedWallet wallet = new SharedWallet(_maxMembers);
        _addNewSharedWallet(address(wallet));
    }

    function _addNewSharedWallet(address _walletAddress) private {
        wallets.push(_walletAddress);
    }

    function getWallets() public view returns (address[] memory) {
        return wallets;
    }
}

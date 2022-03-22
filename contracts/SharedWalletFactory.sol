//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "./SharedWallet.sol";

contract SharedWalletFactory {
    mapping(address => bool) wallets;

    function createNewSharedWallet(uint256 _maxMembers) external {
        SharedWallet wallet = new SharedWallet(_maxMembers);
        addNewSharedWallet(address(wallet));
    }

    function addNewSharedWallet(address _walletAddress) private {
        wallets[_walletAddress] = true;
    }

    function deleteSharedWallet(address _walletAddress, address _benefieciery) external returns(bool) {
        SharedWallet wallet = SharedWallet(_walletAddress);
        wallet.destroy(_benefieciery);
        delete wallets[_walletAddress];
        return true;
    }

}

//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "./SharedWallet.sol";

contract SharedWalletFactory {
    // All wallets ever created
    address[] public wallets;

    // All wallets a specific user is a member of
    mapping(address => address[]) public userWallets;

    // Creates a new wallet instance
    function createNewSharedWallet(uint256 _maxMembers) external {
        SharedWallet wallet = new SharedWallet(_maxMembers);
        _addNewSharedWallet(msg.sender, address(wallet));
    }

    // Stores a newly created wallet in both "wallets" address array and "userWallets" mapping
    function _addNewSharedWallet(address user, address _walletAddress) private {
        wallets.push(_walletAddress);
        userWallets[user].push(_walletAddress);
    }

    // Getter function that returns "wallets" address array (all wallets ever created)
    function getWallets() public view returns (address[] memory) {
        return wallets;
    }
}

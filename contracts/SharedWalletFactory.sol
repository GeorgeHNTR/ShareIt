//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "./SharedWallet.sol";

contract SharedWalletFactory {
    mapping(address => address[]) public userWallets;

    function createNewSharedWallet(uint256 _maxMembers) external {
        SharedWallet wallet = new SharedWallet(_maxMembers);
        userWallets[msg.sender].push(address(wallet));
    }

    function addWalletToUser(address _walletAddress, address _user) external {
        require(_participatesIn(_user, _walletAddress));
        userWallets[_user].push(_walletAddress);
    }

    function _participatesIn(address user, address walletAddress)
        private
        view
        returns (bool)
    {
        address[] memory walletMembers = SharedWallet(walletAddress)
            .getMembers();
        for (uint8 i = 0; i < walletMembers.length; i++)
            if (walletMembers[i] == user) return true;

        return false;
    }
}

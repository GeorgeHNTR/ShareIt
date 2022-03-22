//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "./SharedWallet.sol";

contract SharedWalletStorage {
    mapping(address => address[]) public usersWallets;

    function addWalletToUser(address _walletAddress, address _user) external {
        require(_participatesIn(_user, _walletAddress));
        usersWallets[_user].push(_walletAddress);
    }

    function _participatesIn(address _user, address _walletAddress)
        private
        view
        returns (bool)
    {
        address[] memory walletMembers = SharedWallet(payable(_walletAddress)).getMembers();
        for (uint8 i = 0; i < walletMembers.length; i++)
            if (walletMembers[i] == _user) return true;

        return false;
    }
}

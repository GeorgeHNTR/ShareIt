//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./SharedWallet.sol";

contract SharedWalletsStorage {
    uint8 private maxWalletsPerUser = 8;
    mapping(address => address[]) public usersWallets;

    modifier onlyMember(address _user) {
        require(SharedWallet(msg.sender).isMember(_user));
        _;
    }

    function addWalletToUser(address _user) external /* onlyMember(_user) */ {
        require(
            usersWallets[_user].length <= maxWalletsPerUser,
            "A single user cannot participate in more than 8 wallets!"
        );
        usersWallets[_user].push(msg.sender);
    }

    function removeWalletForUser(address _user) external /* onlyMember(_user) */ {
        for (uint256 i = 0; i < usersWallets[_user].length; i++)
            if (usersWallets[_user][i] == msg.sender) {
                delete usersWallets[_user][i];
                break;
            }
    }
}

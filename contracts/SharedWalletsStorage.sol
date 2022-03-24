//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract SharedWalletsStorage {
    uint8 public maxWalletsPerUser = 8;
    mapping(address => address[]) public usersWallets;

    function addWalletToUser(address _walletAddress, address _user) external {
        require(msg.sender == _walletAddress);
        require(
            usersWallets[_user].length <= maxWalletsPerUser,
            "A single user cannot participate in more than 8 wallets!"
        );
        usersWallets[_user].push(_walletAddress);
    }

    function removeWalletForUser(address _walletAddress, address _user)
        external
    {
        require(msg.sender == _walletAddress);
        for (uint256 i = 0; i < usersWallets[_user].length; i++)
            if (usersWallets[_user][i] == _walletAddress) {
                delete usersWallets[_user][i];
                break;
            }
    }
}

//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./SharedWallet.sol";

contract SharedWalletsStorage {
    uint8 private maxWalletsPerUser = 8;
    mapping(address => address[]) private usersWallets;

    modifier onlyWalletMember(address _newWallet, address _user) {
        require(SharedWallet(_newWallet).isMember(_user));
        _;
    }

    function getUserWallets() public view returns (address[] memory) {
        return usersWallets[msg.sender];
    }

    function addWalletToUser(address _newWallet, address _user)
        external
        onlyWalletMember(_newWallet, _user)
    {
        require(
            usersWallets[_user].length <= maxWalletsPerUser,
            "A single user cannot participate in more than 8 wallets!"
        );
        usersWallets[_user].push(_newWallet);
    }

    function removeWalletForUser(address _newWallet, address _user)
        external
        onlyWalletMember(_newWallet, _user)
    {
        for (uint256 i = 0; i < usersWallets[_user].length; i++)
            if (usersWallets[_user][i] == _newWallet) {
                delete usersWallets[_user][i];
                break;
            }
    }
}

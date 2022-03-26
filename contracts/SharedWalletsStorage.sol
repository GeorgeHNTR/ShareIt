//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./SharedWallet.sol";

contract SharedWalletsStorage {
    uint8 private _maxWalletsPerUser = 8;
    mapping(address => address[]) private _usersWallets;

    function userWallets() public view returns (address[] memory) {
        return _usersWallets[msg.sender];
    }

    function maxWalletsPerUser() public view returns (uint8) {
        return _maxWalletsPerUser;
    }

    function addWalletToUser(address _newWallet, address _user) external {
        require(SharedWallet(_newWallet).isMember(_user));
        require(
            _usersWallets[_user].length <= _maxWalletsPerUser,
            "A single user cannot participate in more than 8 wallets!"
        );
        _usersWallets[_user].push(_newWallet);
    }

    function removeWalletForUser(address _newWallet, address _user) external {
        require(!SharedWallet(_newWallet).isMember(_user));
        for (uint256 i = 0; i < _usersWallets[_user].length; i++)
            if (_usersWallets[_user][i] == _newWallet) {
                delete _usersWallets[_user][i];
                break;
            }
    }
}

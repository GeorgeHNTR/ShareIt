//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./SharedWallet.sol";

contract SharedWalletsStorage {
    uint8 private _maxWalletsPerUser = 8;
    mapping(address => address[8]) private _usersWallets;

    function userWallets() public view returns (address[8] memory) {
        return _usersWallets[msg.sender];
    }

    function maxWalletsPerUser() public view returns (uint8) {
        return _maxWalletsPerUser;
    }

    function addWalletToUser(address _newWallet, address _user) external {
        require(SharedWallet(_newWallet).isMember(_user));
        for (uint256 i = 0; i < _usersWallets[_user].length; i++)
            if (_usersWallets[_user][i] == address(0x0)) {
                _usersWallets[_user][i] = _newWallet;
                return;
            }
        require(false, "Not enough space to add wallet!");
    }

    function removeWalletForUser(address _oldWallet, address _user) external {
        require(!SharedWallet(_oldWallet).isMember(_user));
        for (uint256 i = 0; i < _usersWallets[_user].length; i++)
            if (_usersWallets[_user][i] == _oldWallet) {
                delete _usersWallets[_user][i];
                return;
            }
    }
}

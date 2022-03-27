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
        require(
            SharedWallet(_newWallet).isMember(_user),
            "User is not a member of this wallet!"
        );
        require(
            _usersWallets[_user].length <= _maxWalletsPerUser,
            "Maximum amount of wallets per user exceeded!"
        );
        _usersWallets[_user].push(_newWallet);
    }

    function removeWalletForUser(address _oldWallet, address _user) external {
        require(!SharedWallet(_oldWallet).isMember(_user));
        for (uint256 i = 0; i < _usersWallets[_user].length; i++)
            if (_usersWallets[_user][i] == _oldWallet) {
                _usersWallets[_user][i] = _usersWallets[_user][
                    _usersWallets[_user].length - 1
                ];
                _usersWallets[_user].pop();
                return;
            }
    }
}

//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./SharedWallet.sol";

contract SharedWalletStorage {
    mapping(address => address[]) private _usersWallets;
    mapping(address => address[]) private _invitations;

    function userWallets() public view returns (address[] memory) {
        return _usersWallets[msg.sender];
    }

    function userInvitations() public view returns (address[] memory) {
        return _invitations[msg.sender];
    }

    function sendUserInvitation(address _user) external {
        require(!SharedWallet(msg.sender).isMember(_user));

        _invitations[_user].push(msg.sender);
    }

    function removeUserInvitation(address _user) external {
        require(!SharedWallet(msg.sender).isMember(_user));
        for (uint256 i = 0; i < _invitations[_user].length; i++)
            if (_invitations[_user][i] == msg.sender) {
                _invitations[_user][i] = _invitations[_user][
                    _invitations[_user].length - 1
                ];
                _invitations[_user].pop();
                return;
            }
    }

    function addWalletToUser(address _newWallet, address _user) external {
        require(
            SharedWallet(_newWallet).isMember(_user),
            "User is not a member of this wallet!"
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

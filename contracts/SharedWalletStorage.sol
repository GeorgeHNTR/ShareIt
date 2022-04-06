//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./SharedWallet.sol";

contract SharedWalletStorage {
    struct Invitation {
        address wallet;
        uint256 requestId;
    }

    mapping(address => address[]) private _usersWallets;
    mapping(address => Invitation[]) private _invitations;

    function userWallets() public view returns (address[] memory) {
        return _usersWallets[msg.sender];
    }

    function getInvitationsWallets() public view returns (address[] memory) {
        address[] memory _wallets = new address[](_invitations[msg.sender].length);
        for (uint256 i = 0; i < _invitations[msg.sender].length; i++)
            _wallets[i] = _invitations[msg.sender][i].wallet;
        return _wallets;
    }

    function getInvitationsRequestsIDs()
        public
        view
        returns (uint256[] memory)
    {
        uint256[] memory _requestsIDs = new uint256[](_invitations[msg.sender].length);
        for (uint256 i = 0; i < _invitations[msg.sender].length; i++)
            _requestsIDs[i] = _invitations[msg.sender][i].requestId;
        return _requestsIDs;
    }

    function sendUserInvitation(address _user, uint256 _requestId) external {
        require(!SharedWallet(msg.sender).isMember(_user));

        _invitations[_user].push(
            Invitation({wallet: msg.sender, requestId: _requestId})
        );
    }

    function removeUserInvitation(address _user) external {
        for (uint256 i = 0; i < _invitations[_user].length; i++)
            if (_invitations[_user][i].wallet == msg.sender) {
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

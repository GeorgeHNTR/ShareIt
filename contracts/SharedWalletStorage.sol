//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./SharedWallet.sol";

error UserIsMember();
error UserIsNotMember();

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
        Invitation[] memory m_msgSenderInvitations = _invitations[msg.sender];
        address[] memory _wallets = new address[](
            m_msgSenderInvitations.length
        );
        for (uint256 i = 0; i < m_msgSenderInvitations.length; i++)
            _wallets[i] = m_msgSenderInvitations[i].wallet;
        return _wallets;
    }

    function getInvitationsRequestsIDs()
        public
        view
        returns (uint256[] memory)
    {
        Invitation[] memory m_msgSenderInvitations = _invitations[msg.sender];
        uint256[] memory _requestsIDs = new uint256[](
            m_msgSenderInvitations.length
        );
        for (uint256 i = 0; i < m_msgSenderInvitations.length; i++)
            _requestsIDs[i] = m_msgSenderInvitations[i].requestId;
        return _requestsIDs;
    }

    function sendUserInvitation(address _user, uint256 _requestId) external {
        if (SharedWallet(payable(msg.sender)).isMember(_user)) revert UserIsMember();

        _invitations[_user].push(
            Invitation({wallet: msg.sender, requestId: _requestId})
        );
    }

    function removeUserInvitation(address _user) external {
        Invitation[] memory m_userInvitations = _invitations[_user];
        for (uint256 i = 0; i < m_userInvitations.length; i++)
            if (m_userInvitations[i].wallet == msg.sender) {
                _invitations[_user][i] = m_userInvitations[
                    m_userInvitations.length - 1
                ];
                _invitations[_user].pop();
                return;
            }
    }

    function addWalletToUser(address _newWallet, address _user) external {
        if (!SharedWallet(payable(_newWallet)).isMember(_user)) revert UserIsNotMember();
        _usersWallets[_user].push(_newWallet);
    }

    function removeWalletForUser(address _oldWallet, address _user) external {
        if (SharedWallet(payable(_oldWallet)).isMember(_user)) revert UserIsMember();
        address[] memory m_userWallets = _usersWallets[_user];
        for (uint256 i = 0; i < m_userWallets.length; i++)
            if (m_userWallets[i] == _oldWallet) {
                _usersWallets[_user][i] = m_userWallets[
                    _usersWallets[_user].length - 1
                ];
                _usersWallets[_user].pop();
                return;
            }
    }
}

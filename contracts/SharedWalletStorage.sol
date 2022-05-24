//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./SharedWallet.sol";
import "./SharedWalletFactory.sol";

error OnlyWalletAllowed();
error Unauthorized();

/// @author Georgi Nikolaev Georgiev
/// @notice Saves all wallets and invitation to the corresponding user
contract SharedWalletStorage {
    struct Invitation {
        address wallet;
        uint256 requestId;
    }

    /// @notice The address of the factory contract
    address public immutable SHARED_WALLET_FACTORY_ADDR;

    mapping(address => address[]) private _usersWallets;
    mapping(address => Invitation[]) private _invitations;

    modifier onlyWallet(address _user) {
        if (SharedWallet(payable(msg.sender)).isMember(_user))
            revert OnlyWalletAllowed();
        _;
    }

    constructor() {
        SHARED_WALLET_FACTORY_ADDR = msg.sender;
    }

    /// @notice Add an invitation to the user invitations list by a wallet at address = msg.sender
    /// @dev Can be executed only by the wallet
    function sendUserInvitation(address _user, uint256 _requestId)
        external
        onlyWallet(_user)
    {
        _invitations[_user].push(
            Invitation({wallet: msg.sender, requestId: _requestId})
        );
    }

    /// @notice Removes an invitation that has been sent to the user by a wallet at address = msg.sender
    /// @dev Can be executed only by the wallet
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

    /// @notice Adds a wallet to the msg.sender wallets list
    /// @dev Can be executed only by the wallet
    function addWalletToUser(address _user) external onlyWallet(_user) {
        _usersWallets[_user].push(msg.sender);
    }

    /// @notice Adds a wallet to the msg.sender wallets list
    /// @dev Can be executed only by the factory
    function addWalletToUser(address _user, address _wallet) external {
        if (msg.sender != SHARED_WALLET_FACTORY_ADDR) revert Unauthorized();
        _usersWallets[_user].push(_wallet);
    }

    /// @notice Clears a wallet from the msg.sender wallets list
    /// @dev Can be executed only by the wallet
    function removeWalletForUser(address _user) external {
        address[] memory m_userWallets = _usersWallets[_user];
        for (uint256 i = 0; i < m_userWallets.length; i++)
            if (m_userWallets[i] == msg.sender) {
                _usersWallets[_user][i] = m_userWallets[
                    _usersWallets[_user].length - 1
                ];
                _usersWallets[_user].pop();
                return;
            }
    }

    /// @return address[] An array of the wallet addresses the msg.sender is member of
    function userWallets() public view returns (address[] memory) {
        return _usersWallets[msg.sender];
    }

    /// @return uint256[] An array of the request IDs that contain an invitation to the msg.sender
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

    /// @return address[] An array of the wallet addresses that have invited the msg.sender to join them
    function getInvitationsWallets() public view returns (address[] memory) {
        Invitation[] memory m_msgSenderInvitations = _invitations[msg.sender];
        address[] memory _wallets = new address[](
            m_msgSenderInvitations.length
        );
        for (uint256 i = 0; i < m_msgSenderInvitations.length; i++)
            _wallets[i] = m_msgSenderInvitations[i].wallet;
        return _wallets;
    }
}

//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/proxy/utils/Initializable.sol";

import "./Voting.sol";
import "./CompoundLender.sol";

error NonMemberOnly();
error InsufficientBalance();
error TransactionFailed();

/// @author Georgi Nikolaev Georgiev
/// @notice Manage members' funds and executes approved requests
/// @dev Constructor missing because of minimal proxy pattern (EIP1167)
contract SharedWallet is
    Voting,
    CompoundLender,
    Initializable,
    ReentrancyGuard
{
    /// @notice The storage contract
    SharedWalletStorage public SHARED_WALLETS_STORAGE;

    /// @notice The name of the this wallet
    string public name;

    /// @notice The number of members in this wallet
    uint256 public membersCount;

    /// @notice Tracks all the members that have ever joined this wallet
    /// @dev Used in order to iterate through them when destroying the wallet
    address[] _membersLog;

    /// @notice Current wallet members' tracker
    mapping(address => bool) public isMember;

    modifier onlyMember() override {
        if (!isMember[msg.sender]) revert MemberOnly();
        _;
    }

    /// @notice Initializes the wallet clone (acts as a constructor)
    /// @dev Can be invoked only ones (and is by the factory contract)
    /// @param _creator The first member of this wallet
    /// @param _walletsStorageAddress The address of the storage contract
    /// @param _name The name of this wallet chosen by the creator
    function initialize(
        address _creator,
        address _walletsStorageAddress,
        string memory _name
    ) public virtual initializer {
        if (bytes(_name).length == 0) revert InvalidInput();

        SHARED_WALLETS_STORAGE = SharedWalletStorage(_walletsStorageAddress);
        _membersLog.push(_creator);
        membersCount++;
        isMember[_creator] = true;
        name = _name;
    }

    /// @notice Delegates the funds to compound
    receive() external payable {
        _supplyETH(msg.value);
    }

    /// @notice Allows each member to leave (no voting required)
    function leave() external onlyMember {
        membersCount--;
        delete isMember[msg.sender];
        SHARED_WALLETS_STORAGE.removeWalletForUser(msg.sender);
    }

    /// @notice Delegates the funds to compound
    /// @dev The underlying token amount must already be sent to this contract
    function supplyERC20(address cTokenAddress, uint256 amount) external {
        _supplyERC20(cTokenAddress, amount);
    }

    function _executeRequest(uint256 _requestID) internal override {
        if (_requests[_requestID].requestType == RequestTypes.AddMember)
            _addMember(_requestID);
        else if (_requests[_requestID].requestType == RequestTypes.RemoveMember)
            _removeMember(_requestID);
        else if (_requests[_requestID].requestType == RequestTypes.Withdraw)
            _requests[_requestID].data2 == 0
                ? _withdraw(_requestID)
                : _withdrawERC20(_requestID);
        else if (_requests[_requestID].requestType == RequestTypes.Destroy)
            _destroy(_requestID);
    }

    function _sendInvitation(address _user, uint256 _requestId)
        internal
        override
    {
        SHARED_WALLETS_STORAGE.sendUserInvitation(_user, _requestId);
    }

    function _removeInvitation(address _user) internal override {
        SHARED_WALLETS_STORAGE.removeUserInvitation(_user);
    }

    function _quorum() internal view override returns (uint256) {
        return membersCount / 2 + 1;
    }

    function _addMember(uint256 _requestId) private {
        Request storage request = _requests[_requestId];

        address newMember = address(request.data);

        if (isMember[newMember]) revert NonMemberOnly();
        _membersLog.push(newMember);
        membersCount++;
        SHARED_WALLETS_STORAGE.addWalletToUser(newMember);
        isMember[newMember] = true;
    }

    function _removeMember(uint256 _requestId) private {
        Request storage request = _requests[_requestId];

        address memberToRemove = address(request.data);

        if (!isMember[memberToRemove]) revert MemberOnly();

        membersCount--;
        delete isMember[memberToRemove];
        SHARED_WALLETS_STORAGE.removeWalletForUser(memberToRemove);
    }

    function _withdraw(uint256 _requestId) private nonReentrant {
        Request storage request = _requests[_requestId];

        if (request.data > address(this).balance) revert InsufficientBalance();
        _redeemETH(request.data);

        (bool success, ) = payable(request.author).call{value: request.data}(
            ""
        );
        if (!success) revert TransactionFailed();
    }

    function _withdrawERC20(uint256 _requestId) private nonReentrant {
        Request storage request = _requests[_requestId];
        uint256 amount = request.data;
        address cTokenAddress = address(request.data2);
        _redeemERC20(cTokenAddress, amount);
    }

    function _destroy(uint256 _requestId) private {
        Request storage request = _requests[_requestId];

        address[] memory m_membersLog = _membersLog;
        for (uint256 i; i < m_membersLog.length; i++) {
            if (isMember[m_membersLog[i]]) {
                delete isMember[m_membersLog[i]];
                SHARED_WALLETS_STORAGE.removeWalletForUser(m_membersLog[i]);
            }
        }

        selfdestruct(payable(address(request.data)));
    }
}

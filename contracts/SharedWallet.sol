//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Voting.sol";
import "./SharedWalletStorage.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/proxy/utils/Initializable.sol";

error NonMemberOnly();
error InsufficientBalance();
error TransactionFailed();

contract SharedWallet is Voting, Initializable, ReentrancyGuard {
    SharedWalletStorage public walletsStorage;
    mapping(address => bool) public isMember;
    address[] _membersLog;
    uint256 public membersCount;
    string public name;

    modifier onlyMember() override {
        if (!isMember[msg.sender]) revert MemberOnly();
        _;
    }

    function initialize(
        address _creator,
        address _walletsStorageAddress,
        string memory _name
    ) public virtual initializer {
        if (bytes(_name).length == 0) revert InvalidInput();

        walletsStorage = SharedWalletStorage(_walletsStorageAddress);
        _membersLog.push(_creator);
        membersCount++;
        isMember[_creator] = true;
        name = _name;
    }

    function _addMember(uint256 _requestId) private {
        Request storage request = _requests[_requestId];

        address newMember = address(request.data);

        if (isMember[newMember]) revert NonMemberOnly();
        _membersLog.push(newMember);
        membersCount++;
        isMember[newMember] = true;
        walletsStorage.addWalletToUser(address(this), newMember);
    }

    function _removeMember(uint256 _requestId) private {
        Request storage request = _requests[_requestId];

        address memberToRemove = address(request.data);

        if (!isMember[memberToRemove]) revert MemberOnly();

        membersCount--;
        delete isMember[memberToRemove];
        walletsStorage.removeWalletForUser(address(this), memberToRemove);
    }

    function _withdraw(uint256 _requestId) private nonReentrant {
        Request storage request = _requests[_requestId];

        if (request.data > address(this).balance) revert InsufficientBalance();

        (bool success, ) = payable(request.author).call{value: request.data}(
            ""
        );
        if (!success) revert TransactionFailed();
    }

    function _destroy(uint256 _requestId) private {
        Request storage request = _requests[_requestId];

        address[] memory m_membersLog = _membersLog;
        for (uint256 i; i < m_membersLog.length; i++) {
            if (isMember[m_membersLog[i]]) {
                delete isMember[m_membersLog[i]];
                walletsStorage.removeWalletForUser(
                    address(this),
                    m_membersLog[i]
                );
            }
        }

        selfdestruct(payable(address(request.data)));
    }

    function leave() external onlyMember {
        membersCount--;
        delete isMember[msg.sender];
        walletsStorage.removeWalletForUser(address(this), msg.sender);
    }

    function _executeRequest(uint256 _requestID) internal override {
        if (_requests[_requestID].requestType == RequestTypes.AddMember)
            _addMember(_requestID);
        else if (_requests[_requestID].requestType == RequestTypes.RemoveMember)
            _removeMember(_requestID);
        else if (_requests[_requestID].requestType == RequestTypes.Withdraw)
            _withdraw(_requestID);
        else if (_requests[_requestID].requestType == RequestTypes.Destroy)
            _destroy(_requestID);
    }

    function _sendInvitation(address _user, uint256 _requestId)
        internal
        override
    {
        walletsStorage.sendUserInvitation(_user, _requestId);
    }

    function _removeInvitation(address _user) internal override {
        walletsStorage.removeUserInvitation(_user);
    }

    function _quorum() internal view override returns (uint256) {
        return membersCount / 2 + 1;
    }

    function deposit() external payable {}
}

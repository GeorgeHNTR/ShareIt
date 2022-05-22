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
    address[] private _members;
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
        _members.push(_creator);
        isMember[_creator] = true;
        name = _name;
    }

    function members() public view returns (address[] memory) {
        return _members;
    }

    function _addMember(uint256 _requestId) private {
        Request storage request = _requests[_requestId];
        _validateRequest(request, RequestTypes.AddMember);

        address newMember = address(request.data);

        if (isMember[newMember]) revert NonMemberOnly();
        _members.push(newMember);
        isMember[newMember] = true;
        walletsStorage.addWalletToUser(address(this), newMember);
    }

    function _removeMember(uint256 _requestId) private {
        Request storage request = _requests[_requestId];
        _validateRequest(request, RequestTypes.RemoveMember);

        address memberToRemove = address(request.data);

        if (isMember[memberToRemove]) revert MemberOnly();

        address[] memory m_members = _members;
        for (uint256 i = 0; i < m_members.length; i++)
            if (m_members[i] == memberToRemove) {
                _members[i] = m_members[m_members.length - 1];
                _members.pop();
                delete isMember[memberToRemove];
                walletsStorage.removeWalletForUser(
                    address(this),
                    memberToRemove
                );
                return;
            }
    }

    function _withdraw(uint256 _requestId) private nonReentrant {
        Request storage request = _requests[_requestId];
        _validateRequest(request, RequestTypes.Withdraw);

        if (request.data <= address(this).balance) revert InsufficientBalance();

        (bool success, ) = payable(request.author).call{value: request.data}(
            ""
        );
        if (!success) revert TransactionFailed();
    }

    function _destroy(uint256 _requestId) private {
        Request storage request = _requests[_requestId];
        _validateRequest(request, RequestTypes.Destroy);

        address[] memory m_members = _members;
        for (uint256 i; i < m_members.length; i++) {
            isMember[m_members[i]] = false;
            walletsStorage.removeWalletForUser(address(this), m_members[i]);
        }

        selfdestruct(payable(address(request.data)));
    }

    function leave() external onlyMember {
        address[] memory m_members = _members;
        for (uint256 i = 0; i < m_members.length; i++)
            if (m_members[i] == msg.sender) {
                _members[i] = m_members[m_members.length - 1];
                _members.pop();
                delete isMember[msg.sender];
                walletsStorage.removeWalletForUser(address(this), msg.sender);
                return;
            }
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

    function _validateRequest(
        Request storage _request,
        RequestTypes _requestType
    ) private view {
        if (_request.requestType != _requestType || _request.approved == false)
            revert InvalidRequest();
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
        return _members.length / 2 + 1;
    }

    function deposit() external payable {}
}

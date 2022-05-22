//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Voting.sol";
import "./SharedWalletStorage.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract SharedWallet is Voting, ReentrancyGuard {
    SharedWalletStorage public immutable walletsStorage;
    mapping(address => bool) public isMember;
    address[] private _members;
    string public name;

    modifier onlyMember() override {
        require(isMember[msg.sender]);
        _;
    }

    constructor(
        address _creator,
        address _walletsStorageAddress,
        string memory name_
    ) {
        require(bytes(name_).length != 0);
        walletsStorage = SharedWalletStorage(_walletsStorageAddress);

        _members.push(_creator);
        isMember[_creator] = true;
        name = name;
    }

    function members() public view returns (address[] memory) {
        return _members;
    }

    function _addMember(uint256 _requestId) private {
        Request storage request = _requests[_requestId];
        _validateRequest(request, RequestTypes.AddMember);

        address newMember = address(request.data);

        require(!isMember[newMember]);
        _members.push(newMember);
        isMember[newMember] = true;
        walletsStorage.addWalletToUser(address(this), newMember);
    }

    function _removeMember(uint256 _requestId) private {
        Request storage request = _requests[_requestId];
        _validateRequest(request, RequestTypes.RemoveMember);

        address memberToRemove = address(request.data);

        require(isMember[memberToRemove]);

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

        require(request.data <= address(this).balance);

        (bool success, ) = payable(request.author).call{value: request.data}(
            ""
        );
        require(success);
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

    function leave() external {
        require(isMember[msg.sender]);

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

    function _tryApproveRequest(uint256 _requestId) internal override {
        uint256 goal = _getMajority(_members.length);
        if (
            _requests[_requestId].proVotersCount == goal &&
            _requests[_requestId].requestType != RequestTypes.AddMember
        ) _requests[_requestId].approved = true;
        else if (
            _requests[_requestId].proVotersCount == goal &&
            _requests[_requestId].requestType == RequestTypes.AddMember &&
            uint8(_requests[_requestId].invitationAccepted) == 2
        ) _requests[_requestId].approved = true;

        if (_requests[_requestId].approved) _executeRequest(_requestId);
    }

    function _executeRequest(uint256 _requestId) private {
        if (_requests[_requestId].requestType == RequestTypes.AddMember)
            _addMember(_requestId);
        else if (_requests[_requestId].requestType == RequestTypes.RemoveMember)
            _removeMember(_requestId);
        else if (_requests[_requestId].requestType == RequestTypes.Withdraw)
            _withdraw(_requestId);
        else if (_requests[_requestId].requestType == RequestTypes.Destroy)
            _destroy(_requestId);
    }

    function _validateRequest(
        Request storage _request,
        RequestTypes _requestType
    ) private view {
        require(_request.requestType == _requestType, "Wrong request id!");
        require(_request.approved == true, "Request is not approved yet!");
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

    function deposit() external payable {}
}

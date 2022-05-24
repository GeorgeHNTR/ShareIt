//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./SharedWalletStorage.sol";

error MemberOnly();
error InvalidRequest();
error InvalidInput();

abstract contract Voting {
    enum RequestTypes {
        AddMember,
        RemoveMember,
        Withdraw,
        Destroy
    }

    enum InvitationState {
        None,
        Pending,
        Accepted,
        Rejected
    }

    struct Request {
        address author;
        RequestTypes requestType;
        uint160 data;
        InvitationState invitationAccepted;
        bool approved;
        uint256 proVotersCount;
        mapping(address => bool) voters;
    }

    mapping(uint256 => Request) internal _requests;

    uint256 public requestsCounter;

    modifier onlyMember() virtual {
        if (false) revert MemberOnly();
        _;
    }

    function createRequest(uint256 _requestTypeIdx, uint160 _data)
        external
        onlyMember
    {
        if (_requestTypeIdx > uint256(type(RequestTypes).max))
            revert InvalidInput();

        if (
            _requestTypeIdx == uint8(RequestTypes.Withdraw) &&
            (_data <= 0 || _data > address(this).balance)
        ) {
            revert InvalidInput();
        } else if (address(_data) == address(0x0)) {
            revert InvalidInput();
        }

        Request storage request = _requests[requestsCounter];

        request.author = msg.sender;
        request.requestType = RequestTypes(_requestTypeIdx);
        request.data = _data;
        request.proVotersCount = 1;
        request.voters[msg.sender] = true;

        uint256 requestID = requestsCounter;

        if (request.requestType == RequestTypes.AddMember) {
            request.invitationAccepted = InvitationState.Pending;
            _sendInvitation(address(_data), requestID);
        } else {
            request.invitationAccepted = InvitationState.None;
        }

        requestsCounter++;

        _tryApproveRequest(requestID);
    }

    function acceptRequest(uint256 _requestID) external onlyMember {
        if (
            _requests[_requestID].approved == true ||
            _requests[_requestID].voters[msg.sender] == true
        ) revert InvalidRequest();
        _requests[_requestID].voters[msg.sender] = true;
        _requests[_requestID].proVotersCount++;
        _tryApproveRequest(_requestID);
    }

    function acceptInvitation(uint256 _requestID) external {
        if (
            _requests[_requestID].requestType != RequestTypes.AddMember ||
            address(_requests[_requestID].data) != msg.sender ||
            _requests[_requestID].invitationAccepted != InvitationState.Pending
        ) revert InvalidRequest();
        _requests[_requestID].invitationAccepted = InvitationState.Accepted;
        _removeInvitation(msg.sender);
        _tryApproveRequest(_requestID);
    }

    function rejectInvitation(uint256 _requestID) external {
        if (
            _requests[_requestID].requestType != RequestTypes.AddMember ||
            address(_requests[_requestID].data) != msg.sender ||
            _requests[_requestID].invitationAccepted != InvitationState.Pending
        ) revert InvalidRequest();
        _requests[_requestID].invitationAccepted = InvitationState.Rejected;
        _removeInvitation(msg.sender);
        _requests[_requestID].approved = true; // setting approved to true so members cannot vote anymore but the request leaves not accepted and not executed
    }

    function getRequestDetails(uint256 _id)
        public
        view
        returns (
            address,
            RequestTypes,
            uint160,
            InvitationState,
            bool,
            uint256
        )
    {
        Request storage request = _requests[_id];
        return (
            request.author,
            request.requestType,
            request.data,
            request.invitationAccepted,
            request.approved,
            request.proVotersCount
        );
    }

    function checkMemberHasVotedById(uint256 _id) public view returns (bool) {
        return _requests[_id].voters[msg.sender];
    }

    function _tryApproveRequest(uint256 _requestID) internal virtual {
        uint256 goal = _quorum();
        if (
            _requests[_requestID].proVotersCount == goal &&
            _requests[_requestID].requestType != RequestTypes.AddMember
        ) _requests[_requestID].approved = true;
        else if (
            _requests[_requestID].proVotersCount == goal &&
            _requests[_requestID].requestType == RequestTypes.AddMember &&
            uint8(_requests[_requestID].invitationAccepted) == 2
        ) _requests[_requestID].approved = true;

        if (_requests[_requestID].approved) _executeRequest(_requestID);
    }

    function _quorum() internal virtual returns (uint256) {}

    function _executeRequest(uint256 _requestID) internal virtual {}
    
    function _sendInvitation(address _user, uint256 _requestId)
        internal
        virtual
    {}

    function _removeInvitation(address _user) internal virtual {}
}

//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

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

    uint256 internal _requestsCounter;

    modifier onlyMember() virtual {
        require(false);
        _;
    }

    function requestsCounter() public view returns (uint256) {
        return _requestsCounter;
    }

    function checkRequestIsApprovedById(uint256 _id)
        public
        view
        returns (bool)
    {
        return _requests[_id].approved;
    }

    function checkRequestIsAcceptedById(uint256 _id)
        public
        view
        returns (uint8)
    {
        return uint8(_requests[_id].invitationAccepted);
    }

    function checkMemberHasVotedById(uint256 _id) public view returns (bool) {
        return _requests[_id].voters[msg.sender];
    }

    function getRequestAuthorById(uint256 _id) public view returns (address) {
        return _requests[_id].author;
    }

    function getRequestTypeById(uint256 _id)
        public
        view
        returns (RequestTypes)
    {
        return _requests[_id].requestType;
    }

    function getRequestAddrById(uint256 _id) public view returns (address) {
        require(_requests[_id].requestType != RequestTypes.Withdraw);
        return address(_requests[_id].data);
    }

    function getRequestValueById(uint256 _id) public view returns (uint160) {
        require(_requests[_id].requestType == RequestTypes.Withdraw);
        return _requests[_id].data;
    }

    function getRequestProVotersCountById(uint256 _id)
        public
        view
        returns (uint256)
    {
        return _requests[_id].proVotersCount;
    }

    function createRequest(
        uint256 _requestTypeIdx,
        uint160 _data
    ) external onlyMember {
        require(
            _requestTypeIdx <= uint256(type(RequestTypes).max),
            "Invalid request type!"
        );

        if (_requestTypeIdx == uint8(RequestTypes.Withdraw)) {
            require(_data > 0 && _data <= address(this).balance);
        } else {
            require(address(_data) != address(0x0));
        }

        Request storage request = _requests[_requestsCounter];

        request.author = msg.sender;
        request.requestType = RequestTypes(_requestTypeIdx);
        request.data = _data;
        request.proVotersCount = 1;
        request.voters[msg.sender] = true;

        if (request.requestType == RequestTypes.AddMember) {
            request.invitationAccepted = InvitationState.Pending;
        } else {
            request.invitationAccepted = InvitationState.None;
        }

        uint256 requestID = _requestsCounter;
        _requestsCounter++;

        _tryApproveRequest(requestID);
    }

    function acceptRequest(uint256 _requestID) external onlyMember {
        require(
            _requests[_requestID].approved == false,
            "Request has already passed!"
        );
        require(
            _requests[_requestID].voters[msg.sender] == false,
            "Already voted to this request!"
        );
        _requests[_requestID].voters[msg.sender] = true;
        _requests[_requestID].proVotersCount++;
        _tryApproveRequest(_requestID);
    }

    function acceptInvitation(uint256 _requestID) external {
        require(
            _requests[_requestID].requestType == RequestTypes.AddMember,
            "Wrong request id!"
        );
        require(address(_requests[_requestID].data) == msg.sender);
        require(
            _requests[_requestID].invitationAccepted == InvitationState.Pending,
            "Invitation already accepted!"
        );
        _requests[_requestID].invitationAccepted = InvitationState.Accepted;
        _tryApproveRequest(_requestID);
    }

    function rejectInvitation(uint256 _requestID) external {
        require(
            _requests[_requestID].requestType == RequestTypes.AddMember,
            "Wrong request id!"
        );
        require(address(_requests[_requestID].data) == msg.sender);
        require(
            _requests[_requestID].invitationAccepted == InvitationState.Pending,
            "Invitation already accepted!"
        );
        _requests[_requestID].invitationAccepted = InvitationState.Rejected;
        _requests[_requestID].approved = true; // setting approved to true so members cannot vote anymore but the request leaves not accepted and not executed
    }

    function _tryApproveRequest(uint256 _requestID) internal virtual {
        // uint256 goal = _getMajority(1); // override
        // if (
        //     _requests[_requestID].proVotersCount == goal &&
        //     _requests[_requestID].requestType != RequestTypes.AddMember
        // ) {
        //     _requests[_requestID].approved = true;
        // } else if (
        //     _requests[_requestID].proVotersCount == goal &&
        //     _requests[_requestID].requestType == RequestTypes.AddMember &&
        //     _requests[_requestID].accepted
        // ) {
        //     _requests[_requestID].approved = true;
        // }
    }

    function _getMajority(uint256 _total) internal pure returns (uint256) {
        return _total / 2 + 1;
    }
}

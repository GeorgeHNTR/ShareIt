//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./SharedWalletStorage.sol";

error MemberOnly();
error InvalidRequest();
error InvalidInput();

/// @author Georgi Nikolaev Georgiev
/// @notice Manages a shared wallet's members' requests and invitation
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
        uint160 data2; //additional data if needed
        InvitationState invitationAccepted;
        bool approved;
        uint256 proVotersCount;
        mapping(address => bool) voters;
    }

    mapping(uint256 => Request) internal _requests;

    /// @notice The ID of the next request
    /// @dev Increments to create unique IDs for each request
    uint256 public requestsCounter;

    modifier onlyMember() virtual {
        if (false) revert MemberOnly();
        _;
    }

    /// @notice Creates and posts new requests
    /// @param _requestTypeIdx A number which represents the request type
    /// @param _data A number or an address
    function createRequest(uint256 _requestTypeIdx, uint160 _data)
        external
        onlyMember
    {
        createRequest(_requestTypeIdx, _data, 0);
    }

    /// @notice Creates and posts new requests
    /// @dev If there is only one wallet member, it automatically passes
    /// @param _requestTypeIdx A number which represents the request type
    /// @param _data A number or an address
    /// @param _data2 Additional data param
    /// @dev The _data param is casted to address if the request type is not "Withdraw"
    /// @dev The _data2 param is used when withdrawing ERC20s to point at the cToken address
    function createRequest(
        uint256 _requestTypeIdx,
        uint160 _data,
        uint160 _data2
    ) public onlyMember {
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
        request.data2 = _data2;
        request.proVotersCount = 1;
        request.voters[msg.sender] = true;

        uint256 requestID = requestsCounter;
        requestsCounter++;

        if (request.requestType == RequestTypes.AddMember) {
            request.invitationAccepted = InvitationState.Pending;
            _sendInvitation(address(_data), requestID);
        } else {
            request.invitationAccepted = InvitationState.None;
        }

        _tryApproveRequest(requestID);
    }

    /// @notice Invoked by each member that has not voted for a specific requset yet
    /// @param _requestID The ID of the request the user wants to accept
    function acceptRequest(uint256 _requestID) external onlyMember {
        if (
            _requests[_requestID].approved == true ||
            _requests[_requestID].voters[msg.sender] == true
        ) revert InvalidRequest();
        _requests[_requestID].voters[msg.sender] = true;
        _requests[_requestID].proVotersCount++;
        _tryApproveRequest(_requestID);
    }

    /// @notice Invoked by a member that has been invited to join this wallet and wants to
    /// @param _requestID The ID of a request of type "AddMember"
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

    /// @notice Invoked by a member that has been invited to join this wallet, but does not want to
    /// @param _requestID The ID of a request of type "AddMember"
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

    /// @param _id The ID of the request
    /// @return address The address of the request author
    /// @return RequestTypes The request type
    /// @return uint160 The data attached to the request
    /// @return uint160 The additional data attached to the request
    /// @dev The data can be kept as a number or casted to address on the client if needed
    /// @return InvitationState The state of the request invitation (if there is one)
    /// @return bool Is the request approved yet
    /// @return uint256 The number of positive voters of this request
    function getRequestDetails(uint256 _id)
        public
        view
        returns (
            address,
            RequestTypes,
            uint160,
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
            request.data2,
            request.invitationAccepted,
            request.approved,
            request.proVotersCount
        );
    }

    /// @notice Checks if a member has voted positive for a specific request
    /// @param _id The ID of the request
    /// @return bool Has the msg.sender already accepted for this request
    function checkMemberHasVotedById(uint256 _id) public view returns (bool) {
        return _requests[_id].voters[msg.sender];
    }

    function _tryApproveRequest(uint256 _requestID) internal virtual {
        uint256 goal = _quorum();
        if (_requests[_requestID].proVotersCount != goal) return;

        if (
            _requests[_requestID].requestType == RequestTypes.AddMember &&
            _requests[_requestID].invitationAccepted != InvitationState.Accepted
        ) return;

        _requests[_requestID].approved = true;
        _executeRequest(_requestID);
    }

    function _quorum() internal virtual returns (uint256) {}

    function _executeRequest(uint256 _requestID) internal virtual {}

    function _sendInvitation(address _user, uint256 _requestId)
        internal
        virtual
    {}

    function _removeInvitation(address _user) internal virtual {}
}

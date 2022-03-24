//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

abstract contract Voting {
    enum RequestTypes {
        AddMember,
        RemoveMember,
        Withdraw,
        Destroy
    }

    struct Request {
        address author;
        RequestTypes requestType;
        address addr;
        uint256 value;
        bool approved;
        bool accepted;
        uint256 proVotersCount;
        mapping(address => bool) voters;
    }

    mapping(uint256 => Request) public requests;

    uint256 public requestsCounter;

    modifier onlyMember() virtual {
        _;
    }

    function createRequest(
        RequestTypes _requestType,
        uint256 _value,
        address _addr
    ) external onlyMember returns (uint256) {
        require(uint256(_requestType) <= 3, "Invalid request type!");

        if (_requestType == RequestTypes.Withdraw) {
            require(_value >= 0);
            require(_addr == address(0x0));
        } else {
            require(_value == 0);
            require(_addr != address(0x0));
        }

        Request storage request = requests[requestsCounter];

        request.author = msg.sender;
        request.requestType = _requestType;
        request.addr = _addr;
        request.value = _value;
        request.proVotersCount = 1;
        request.approved = false;

        uint256 requestID = requestsCounter;
        requestsCounter++;

        return requestID;
    }

    function acceptRequest(uint256 _requestID) external onlyMember {
        require(
            requests[_requestID].voters[msg.sender] == false,
            "Already voted to this request!"
        );
        requests[_requestID].voters[msg.sender] == true;
        requests[_requestID].proVotersCount++;
        _tryApproveRequest(_requestID);
    }

    function acceptInvitation(uint256 _requestID) external {
        require(
            requests[_requestID].requestType == RequestTypes.AddMember,
            "Wrong request id!"
        );
        require(requests[_requestID].addr == msg.sender);
        requests[_requestID].accepted = true;
    }

    function _tryApproveRequest(uint256 _requestID) internal virtual {
        uint256 goal = _getMajority(1); // override
        if (
            requests[_requestID].proVotersCount == goal &&
            requests[_requestID].requestType != RequestTypes.AddMember
        ) {
            requests[_requestID].approved = true;
        } else if (
            requests[_requestID].proVotersCount == goal &&
            requests[_requestID].requestType == RequestTypes.AddMember &&
            requests[_requestID].accepted
        ) {
            requests[_requestID].approved = true;
        }
    }

    function _getMajority(uint256 _total) internal pure returns (uint256) {
        return _total / 2 + 1;
    }
}

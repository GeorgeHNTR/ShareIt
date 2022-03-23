//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "./SharedWallet.sol";

contract Voting {
    enum RequestTypes {
        AddMember,
        RemoveMember,
        Withdraw,
        Destroy
    }

    struct Request {
        address proposer;
        RequestTypes requestType;
        bytes20 data; // either an address or an amount of wei to withdraw (bytes20 can be casted to both uint256 and address types)
        uint256 proVotersCount;
        mapping(address => bool) voters;
        bool approved;
    }

    mapping(uint256 => Request) public requests;

    uint256 public requestsCounter;

    function createRequest(RequestTypes _requestType, bytes20 _data)
        external
        returns (uint256)
    {
        require(uint256(_requestType) <= 3, "Invalid request type!");

        Request storage request = requests[requestsCounter];

        request.proposer = msg.sender;
        request.requestType = _requestType;
        request.data = _data;
        request.proVotersCount = 0;
        request.approved = false;

        uint256 requestID = requestsCounter;
        requestsCounter++;

        return requestID;
    }

    function acceptRequest(uint256 _requestID) external {
        require(
            requests[_requestID].voters[msg.sender] == false,
            "Already voted to this request!"
        );
        requests[_requestID].voters[msg.sender] == true;
        requests[_requestID].proVotersCount++;
        tryApproveRequest(_requestID);
    }

    function tryApproveRequest(uint256 _requestID) public virtual {
        // uint256 goal = 1;  // <- change
        // if (requests[_requestID].votersCount == goal)
        //     requests[_requestID].approved = true;
    }
}

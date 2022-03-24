//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "./Voting.sol";
import "./SharedWalletStorage.sol";

contract SharedWallet is Voting {
    SharedWalletStorage walletStorage;
    uint256 public maxMembers;
    mapping(address => bool) isMember;
    address[] public members;

    modifier onlyMember() override {
        require(isMember[msg.sender]);
        _;
    }

    constructor(
        address _creator,
        uint256 _maxMembers,
        SharedWalletStorage _walletStorage
    ) {
        require(
            _maxMembers <= 12,
            "Cannot have more than 12 members in a single shared wallet!"
        );

        walletStorage = _walletStorage;
        maxMembers = _maxMembers;

        members.push(_creator);
        isMember[_creator] = true;
        walletStorage.addWalletToUser(address(this), _creator);
    }

    function getMembers() public view returns (address[] memory) {
        return members;
    }

    function addMember(uint256 _requestId) external returns (bool) {
        Request storage request = requests[_requestId];
        require(
            request.author == msg.sender,
            "You are not the author of this request!"
        );
        require(request.approved == true, "Request is not approved yet!");
        require(
            request.requestType == RequestTypes.AddMember,
            "Wrong request id!"
        );

        require(
            members.length < maxMembers,
            "Maximum number of members reached!"
        );

        members.push(request.addr);
        isMember[request.addr] = true;
        walletStorage.addWalletToUser(address(this), request.addr);
        return true;
    }

    function removeMember(uint256 _requestId) external returns (bool) {
        Request storage request = requests[_requestId];
        require(
            request.author == msg.sender,
            "You are not the author of this request!"
        );
        require(request.approved == true, "Request is not approved yet!");
        require(
            request.requestType == RequestTypes.RemoveMember,
            "Wrong request id!"
        );

        for (uint256 i = 0; i < members.length; i++)
            if (members[i] == request.addr) {
                address deletedMember = members[i];
                delete members[i];
                delete isMember[deletedMember];
                walletStorage.removeWalletForUser(address(this), deletedMember);
                return true;
            }

        return false;
    }

    function withdraw(uint256 _requestId) external returns (bool) {
        Request storage request = requests[_requestId];
        require(
            request.author == msg.sender,
            "You are not the author of this request!"
        );
        require(request.approved == true, "Request is not approved yet!");
        require(
            request.requestType == RequestTypes.Withdraw,
            "Wrong request id!"
        );

        require(request.value <= address(this).balance);

        return payable(msg.sender).send(request.value);
    }

    function destroy(uint256 _requestId) external returns (bool) {
        Request storage request = requests[_requestId];
        require(
            request.author == msg.sender,
            "You are not the author of this request!"
        );
        require(request.approved == true, "Request is not approved yet!");
        require(
            request.requestType == RequestTypes.Withdraw,
            "Wrong request id!"
        );

        selfdestruct(payable(request.addr));
        return true;
    }

    function _tryApproveRequest(uint256 _requestID) internal override {
        uint256 goal = _getMajority(members.length);
        if (requests[_requestID].proVotersCount == goal)
            requests[_requestID].approved = true;
    }

    receive() external payable {}

    fallback() external payable {}
}

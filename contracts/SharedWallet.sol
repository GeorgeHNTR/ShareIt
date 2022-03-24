//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Voting.sol";
import "./SharedWalletsStorage.sol";

contract SharedWallet is Voting {
    SharedWalletsStorage walletsStorage;
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
        SharedWalletsStorage _walletsStorage
    ) {
        require(
            _maxMembers <= 12,
            "Cannot have more than 12 members in a single shared wallet!"
        );

        walletsStorage = _walletsStorage;
        maxMembers = _maxMembers;

        members.push(_creator);
        isMember[_creator] = true;
        walletsStorage.addWalletToUser(address(this), _creator);
    }

    function getMembers() public view returns (address[] memory) {
        return members;
    }

    function addMember(uint256 _requestId) external returns (bool) {
        Request storage request = requests[_requestId];
        _validateRequest(request, RequestTypes.AddMember);

        require(
            members.length < maxMembers,
            "Maximum number of members reached!"
        );

        members.push(request.addr);
        isMember[request.addr] = true;
        walletsStorage.addWalletToUser(address(this), request.addr);
        return true;
    }

    function removeMember(uint256 _requestId) external returns (bool) {
        Request storage request = requests[_requestId];
        _validateRequest(request, RequestTypes.RemoveMember);

        for (uint256 i = 0; i < members.length; i++)
            if (members[i] == request.addr) {
                address deletedMember = members[i];
                delete members[i];
                delete isMember[deletedMember];
                walletsStorage.removeWalletForUser(address(this), deletedMember);
                return true;
            }

        return false;
    }

    function withdraw(uint256 _requestId) external returns (bool) {
        Request storage request = requests[_requestId];
        _validateRequest(request, RequestTypes.Withdraw);

        require(request.value <= address(this).balance);

        return payable(msg.sender).send(request.value);
    }

    function destroy(uint256 _requestId) external returns (bool) {
        Request storage request = requests[_requestId];
        _validateRequest(request, RequestTypes.Destroy);

        selfdestruct(payable(request.addr));
        return true;
    }

    function _tryApproveRequest(uint256 _requestID) internal override {
        uint256 goal = _getMajority(members.length);
        if (requests[_requestID].proVotersCount == goal)
            requests[_requestID].approved = true;
    }

    function _validateRequest(
        Request storage _request,
        RequestTypes _requestType
    ) private view {
        require(
            _request.author == msg.sender,
            "You are not the author of this request!"
        );
        require(_request.approved == true, "Request is not approved yet!");
        require(_request.requestType == _requestType, "Wrong request id!");
    }

    receive() external payable {}

    fallback() external payable {}
}

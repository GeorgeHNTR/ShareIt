//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Voting.sol";
import "./SharedWalletsStorage.sol";

contract SharedWallet is Voting {
    SharedWalletsStorage private _walletsStorage;
    mapping(address => bool) private _isMember;
    address[] private _members;
    string private _name;

    modifier onlyMember() override {
        require(_isMember[msg.sender]);
        _;
    }

    constructor(address _creator, address _walletsStorageAddress) {
        _walletsStorage = SharedWalletsStorage(_walletsStorageAddress);

        _members.push(_creator);
        _isMember[_creator] = true;
    }

    function members() public view returns (address[] memory) {
        return _members;
    }

    function name() public view returns (string memory) {
        return _name;
    }

    function walletsStorage() public view returns (SharedWalletsStorage) {
        return _walletsStorage;
    }

    function isMember(address _user) public view returns (bool) {
        return _isMember[_user];
    }

    function addMember(uint256 _requestId) external returns (bool) {
        Request storage request = _requests[_requestId];
        _validateRequest(request, RequestTypes.AddMember);

        _members.push(request.addr);
        _isMember[request.addr] = true;
        _walletsStorage.addWalletToUser(address(this), request.addr);
        return true;
    }

    function removeMember(uint256 _requestId) external returns (bool) {
        Request storage request = _requests[_requestId];
        _validateRequest(request, RequestTypes.RemoveMember);

        for (uint256 i = 0; i < _members.length; i++)
            if (_members[i] == request.addr) {
                address deletedMember = _members[i];
                delete _members[i];
                delete _isMember[deletedMember];
                _walletsStorage.removeWalletForUser(
                    address(this),
                    deletedMember
                );
                return true;
            }

        return false;
    }

    function withdraw(uint256 _requestId) external returns (bool) {
        Request storage request = _requests[_requestId];
        _validateRequest(request, RequestTypes.Withdraw);

        require(request.value <= address(this).balance);

        return payable(msg.sender).send(request.value);
    }

    function destroy(uint256 _requestId) external returns (bool) {
        Request storage request = _requests[_requestId];
        _validateRequest(request, RequestTypes.Destroy);

        selfdestruct(payable(request.addr));
        return true;
    }

    function _tryApproveRequest(uint256 _requestID) internal override {
        uint256 goal = _getMajority(_members.length);
        if (
            _requests[_requestID].proVotersCount == goal &&
            _requests[_requestID].requestType != RequestTypes.AddMember
        ) {
            _requests[_requestID].approved = true;
        } else if (
            _requests[_requestID].proVotersCount == goal &&
            _requests[_requestID].requestType == RequestTypes.AddMember &&
            _requests[_requestID].accepted
        ) {
            _requests[_requestID].approved = true;
        }
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

    function deposit() external payable {}
}

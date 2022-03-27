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

    constructor(address _creator, address _walletsStorageAddress, string memory name_) {
        _walletsStorage = SharedWalletsStorage(_walletsStorageAddress);

        _members.push(_creator);
        _isMember[_creator] = true;
        _name = name_;
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

    function _addMember(uint256 _requestId) private {
        Request storage request = _requests[_requestId];
        _validateRequest(request, RequestTypes.AddMember);

        require(!isMember(request.addr));
        _members.push(request.addr);
        _isMember[request.addr] = true;
        _walletsStorage.addWalletToUser(address(this), request.addr);
    }

    function _removeMember(uint256 _requestId) private {
        Request storage request = _requests[_requestId];
        _validateRequest(request, RequestTypes.RemoveMember);

        for (uint256 i = 0; i < _members.length; i++)
            if (_members[i] == request.addr) {
                address deletedMember = _members[i];
                _members[i] = _members[_members.length - 1];
                _members.pop();
                delete _isMember[deletedMember];
                _walletsStorage.removeWalletForUser(
                    address(this),
                    deletedMember
                );
                return;
            }
    }

    function _withdraw(uint256 _requestId) private {
        Request storage request = _requests[_requestId];
        _validateRequest(request, RequestTypes.Withdraw);

        require(request.value <= address(this).balance);

        payable(tx.origin).transfer(request.value);
    }

    function _destroy(uint256 _requestId) private {
        Request storage request = _requests[_requestId];
        _validateRequest(request, RequestTypes.Destroy);

        selfdestruct(payable(request.addr));
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
            _requests[_requestId].accepted
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

    function deposit() external payable {}
}

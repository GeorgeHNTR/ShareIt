//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Voting.sol";
import "./SharedWalletStorage.sol";

contract SharedWallet is Voting {
    SharedWalletStorage private _walletsStorage;
    mapping(address => bool) private _isMember;
    address[] private _members;
    string private _name;

    modifier onlyMember() override {
        require(_isMember[msg.sender]);
        _;
    }

    constructor(
        address _creator,
        address _walletsStorageAddress,
        string memory name_
    ) {
        require(bytes(name_).length != 0);
        _walletsStorage = SharedWalletStorage(_walletsStorageAddress);

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

    function walletsStorage() public view returns (SharedWalletStorage) {
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

        require(isMember(request.addr));
        for (uint256 i = 0; i < _members.length; i++)
            if (_members[i] == request.addr) {
                _members[i] = _members[_members.length - 1];
                _members.pop();
                delete _isMember[request.addr];
                _walletsStorage.removeWalletForUser(
                    address(this),
                    request.addr
                );
                return;
            }
    }

    function _withdraw(uint256 _requestId) private {
        Request storage request = _requests[_requestId];
        _validateRequest(request, RequestTypes.Withdraw);

        require(request.value <= address(this).balance);

        payable(request.author).transfer(request.value);
    }

    function _destroy(uint256 _requestId) private {
        Request storage request = _requests[_requestId];
        _validateRequest(request, RequestTypes.Destroy);

        selfdestruct(payable(request.addr));
    }

    function leave() external {
        require(isMember(msg.sender));
        for (uint256 i = 0; i < _members.length; i++)
            if (_members[i] == msg.sender) {
                _members[i] = _members[_members.length - 1];
                _members.pop();
                delete _isMember[msg.sender];
                _walletsStorage.removeWalletForUser(address(this), msg.sender);
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

    function deposit() external payable {}
}

//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract SharedWallet {
    address creator;
    uint256 public maxMembers;
    address[] members;

    modifier onlyCreator() {
        require(msg.sender == creator);
        _;
    }

    modifier onlyMember() {
        bool isMember = false;
        for (uint8 i = 0; i < members.length; i++)
            if (members[i] == tx.origin) {
                isMember = true; 
                break;
            }

        require(isMember);
        _;
    }

    constructor(uint256 _maxMembers) {
        require(
            _maxMembers <= 12,
            "Cannot have more than 12 members in a single shared wallet!"
        );

        creator = msg.sender;
        maxMembers = _maxMembers;
        members.push(msg.sender);
    }

    function addMember(address _newMember) private returns (bool) {
        require(
            members.length < maxMembers,
            "Maximum number of members reached!"
        );

        members.push(_newMember);
        return true;
    }

    function removeMember(address _member) private returns (bool) {
        for (uint8 i = 0; i < members.length; i++)
            if (members[i] == _member) {
                delete members[i];
                return true;
            }

        return false;
    }

    function destroy(address _benefieciery) external onlyCreator onlyMember {
        selfdestruct(payable(_benefieciery));
    }
}

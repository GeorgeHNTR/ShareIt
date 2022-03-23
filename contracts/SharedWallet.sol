//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "./SharedWalletStorage.sol";
import "./SharedWalletFactory.sol";

contract SharedWallet {
    SharedWalletStorage walletStorage;
    uint256 public maxMembers;
    address[] public members;

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

    constructor(address _creator, uint256 _maxMembers, SharedWalletStorage _walletStorage) {
        require(
            _maxMembers <= 12,
            "Cannot have more than 12 members in a single shared wallet!"
        );

        walletStorage = _walletStorage;
        maxMembers = _maxMembers;

        members.push(_creator);
        _addMember(_creator);
    }

    function getMembers() public view returns (address[] memory) {
        return members;
    }

    function _addMember(address _newMember) private returns (bool) {
        // add voting
        require(
            members.length < maxMembers,
            "Maximum number of members reached!"
        );

        members.push(_newMember);
        walletStorage.addWalletToUser(address(this), _newMember);
        return true;
    }

    function _removeMember(address _member) private returns (bool) {
        // add voting
        for (uint256 i = 0; i < members.length; i++)
            if (members[i] == _member) {
                address deletedMember = members[i];
                delete members[i];
                walletStorage.removeWalletForUser(address(this), deletedMember);
                return true;
            }

        return false;
    }

    function _withdraw(uint256 amountInWei) private returns (bool) {
        // add voting
        require(amountInWei <= address(this).balance);

        return payable(msg.sender).send(amountInWei);
    }

    function destroy(address _benefieciery) external onlyMember {
        // add voting
        selfdestruct(payable(_benefieciery));
    }

    receive() external payable {}

    fallback() external payable {}

}

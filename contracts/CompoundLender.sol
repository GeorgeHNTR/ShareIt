//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import "./Compound/CTokenInterface.sol";
import "./Compound/CEthInterface.sol";

error Compound__SupplyFailed();
error Compound__RedeemFailed();

/// @author Georgi Nikolaev Georgiev
/// @notice Responsible for compound lending
contract CompoundLender {
    address constant CETH_ADDRESS = 0x859e9d8a4edadfEDb5A2fF311243af80F85A91b8;

    /// @notice Lends ERC20 tokens
    /// @dev The underlying token amount must already be sent to this contract
    function supplyERC20(address cTokenAddress, uint256 underlyingAmount)
        internal
    {
        CTokenInterface cToken = CTokenInterface(cTokenAddress);
        address underlyingAddress = cToken.underlying();
        IERC20(underlyingAddress).approve(cTokenAddress, underlyingAmount);
        uint256 result = cToken.mint(underlyingAmount);
        if (result != 0) revert Compound__SupplyFailed();
    }

    /// @notice Redeems ERC20 tokens to this contract
    function redeemERC20(address cTokenAddress, uint256 cTokenAmount) internal {
        CTokenInterface cToken = CTokenInterface(cTokenAddress);
        uint256 result = cToken.redeem(cTokenAmount);
        if (result != 0) revert Compound__RedeemFailed();
    }

    /// @notice Lends ether
    /// @dev The ether amount must already be sent to this contract
    function supplyETH(uint256 cEthAmount) internal {
        CEthInterface cEth = CEthInterface(CETH_ADDRESS);
        cEth.mint{value: cEthAmount}();
    }

    /// @notice Redeems ether to this contract
    function redeemETH(uint256 cEthAmount) internal {
        CEthInterface cEth = CEthInterface(CETH_ADDRESS);
        uint256 result = cEth.redeem(cEthAmount);
        if (result != 0) revert Compound__RedeemFailed();
    }
}

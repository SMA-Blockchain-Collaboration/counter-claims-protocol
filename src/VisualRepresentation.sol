// SPDX-License-Identifier: MIT
// Creates visual representations for claims, linked to their metadata. 
pragma solidity ^0.8.0;

import "lib/openzeppelin-contracts-upgradeable/contracts/proxy/utils/Initializable.sol";
import "lib/openzeppelin-contracts-upgradeable/contracts/proxy/utils/UUPSUpgradeable.sol";
import "lib/openzeppelin-contracts-upgradeable/contracts/access/OwnableUpgradeable.sol";

// We might want to use a proxy contract and make this upgradeable
contract VisualRepresentation is Initializable, UUPSUpgradeable, OwnableUpgradeable  {

    mapping(uint256 => string) public visuals;

    function generateVisual(uint256 claimId, string calldata inputData) public {
        //reading inputData for the visual.
        //currently it is a string, but could be turned into however we want it stored.
    }

    function _authorizeUpgrade(
        address newImplementation
    ) internal override onlyOwner {}
}
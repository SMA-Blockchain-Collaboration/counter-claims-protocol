// SPDX-License-Identifier: MIT
// Creates visual representations for claims, linked to their metadata. 
pragma solidity ^0.8.0;

import "lib/openzeppelin-contracts-upgradeable/contracts/proxy/utils/Initializable.sol";

contract VisualRepresentation is Initializable {

    mapping(uint256 => string) public visuals;

    function generateVisual(uint256 claimId, string calldata inputData) public {
        //reading inputData for the 
    }


}
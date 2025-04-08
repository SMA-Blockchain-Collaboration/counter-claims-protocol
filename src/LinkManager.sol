// SPDX-License-Identifier: MIT
// Creates shareable links for claims and the "Earth" token account.
pragma solidity ^0.8.0;

import "lib/openzeppelin-contracts-upgradeable/contracts/proxy/utils/Initializable.sol";

contract LinkManager is Initializable {

    mapping(uint256 => string) public links;

    function generateLink(uint256 claimId) public {

    }

    function generateEarthLink() public {
        //in case we decide to create ERC-6551 token for Earth
    }
}

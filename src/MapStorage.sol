// SPDX-License-Identifier: MIT
// Maps geospatial data to claims and enables location-based queries.
pragma solidity ^0.8.0;

import "lib/openzeppelin-contracts-upgradeable/contracts/proxy/utils/Initializable.sol";

contract MapStorage is Initializable {

    struct Pin {
        uint256 claimId;
        uint256 lat;
        uint256 long;
    }

    mapping(uint256 => Pin[]) public pins;

    function addPin(uint256 claimId, uint256 lat, uint256 long) public {
    
    }

    function getPins(uint256 lat, uint256 long, uint256 radius) public {

    }

}

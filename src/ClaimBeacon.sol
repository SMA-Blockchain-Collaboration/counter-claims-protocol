// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/proxy/beacon/UpgradeableBeacon.sol";

contract ClaimBeacon is UpgradeableBeacon {
    constructor(
        address initialImplementation,
        address owner
    ) UpgradeableBeacon(initialImplementation, owner) {
        transferOwnership(owner); // Transfer ownership to the specified owner
    }

    function upgradeTo(address newImplementation) public override onlyOwner {
        super.upgradeTo(newImplementation); // Call the parent implementation
    }
}

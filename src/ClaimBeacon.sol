// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/proxy/beacon/UpgradeableBeacon.sol";

contract ClaimBeacon is UpgradeableBeacon {
    error OwnableUnauthorizedAccount(address account); // Declare the custom error

    constructor(
        address initialImplementation,
        address owner
    ) UpgradeableBeacon(initialImplementation, owner) {
        transferOwnership(owner); // Transfer ownership to the specified owner
    }

    function upgradeTo(address newImplementation) public override onlyOwner {
        if (msg.sender != owner()) {
            revert OwnableUnauthorizedAccount(msg.sender); // Use the custom error for unauthorized access
        }
        super.upgradeTo(newImplementation); // Call the parent implementation
    }
}

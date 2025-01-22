// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../src/ClaimLogic.sol";
import "../src/ClaimBeacon.sol";
import "../src/ClaimProxy.sol";

contract DeployContracts {
    ClaimLogic public logic;
    ClaimBeacon public beacon;

    function deploy() public {
        // Deploy logic implementation
        logic = new ClaimLogic();

        // Deploy beacon
        beacon = new ClaimBeacon(address(logic), msg.sender);

        // Deploy a proxy (for demonstration)
        ClaimProxy proxy = new ClaimProxy(address(beacon), "");
    }
}

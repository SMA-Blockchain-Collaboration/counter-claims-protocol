// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "../src/ClaimLogic.sol";
import "@openzeppelin/contracts/proxy/beacon/UpgradeableBeacon.sol";
import "@openzeppelin/contracts/proxy/beacon/BeaconProxy.sol";

contract DeployScript is Script {
    function run() external {
        vm.startBroadcast();

        // Deploy the logic contract
        ClaimLogic logic = new ClaimLogic();

        // Deploy the beacon
        UpgradeableBeacon beacon = new UpgradeableBeacon(address(logic), msg.sender);

        // Deploy the proxy
        BeaconProxy proxy = new BeaconProxy(
            address(beacon),
            abi.encodeWithSignature("initialize()")
        );

        vm.stopBroadcast();
    }
}

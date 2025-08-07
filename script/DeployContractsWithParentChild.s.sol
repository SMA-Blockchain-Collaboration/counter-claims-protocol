// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "../src/ClaimLogic.sol";
import "../src/ClaimBeacon.sol";
import "../src/ClaimProxy.sol";
import "@openzeppelin/contracts/proxy/beacon/UpgradeableBeacon.sol";
import "@openzeppelin/contracts/proxy/beacon/BeaconProxy.sol";

contract DeployContractsWithParentChild is Script {
    function run() external {

        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address initialOwner = vm.envAddress("INITIAL_OWNER");
        address secondClaimer = vm.envAddress("SECOND_CLAIMER");

        vm.startBroadcast(deployerPrivateKey);

        // Deploy the logic contract
        ClaimLogic logic = new ClaimLogic();

        // Deploy the beacon
        ClaimBeacon beacon = new ClaimBeacon(address(logic), msg.sender);

        // Encode data for initialize call
        bytes memory initData = abi.encodeWithSignature(
            "initialize(address,address)",
            initialOwner,
            secondClaimer
        );

        // Deploy the proxy
        ClaimProxy proxy = new ClaimProxy(
            address(beacon), initData
        );

        ClaimLogic claimLogic = ClaimLogic(address(proxy));

        console.log("ClaimLogic Proxy deployed at:", address(claimLogic));
        console.log("Logic (implementation) at:", address(logic));
        console.log("Beacon at:", address(beacon));

        //Depending on how it is written, can mint Earth here, and lock it so it's non-transferrable

        vm.stopBroadcast();
    }
}

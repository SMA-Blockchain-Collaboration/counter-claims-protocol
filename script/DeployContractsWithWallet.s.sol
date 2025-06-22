// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "../src/ClaimLogic.sol";
import "../src/ClaimBeacon.sol";
import "../src/ClaimProxy.sol";
import "../src/EarthWallet.sol";
import "../src/DeployEarthWallet.sol";
import "@openzeppelin/contracts/proxy/beacon/UpgradeableBeacon.sol";
import "@openzeppelin/contracts/proxy/beacon/BeaconProxy.sol";

contract DeployScript is Script {
    function run() external {
        vm.startBroadcast();
      
        // Deploy the logic contract
        ClaimLogic logic = new ClaimLogic();
        logic.initialize(msg.sender);
        
        DeployEarthWallet earthFactory = new DeployEarthWallet();
        
        //Depending on how it is written, can mint Earth here, and lock it so it's non-transferrable

        // deploy the Earth Wallet from address with claimId 0
        address earthWalletAddress = earthFactory.deploy(address(logic), 0);

        // Deploy the beacon
        ClaimBeacon beacon = new ClaimBeacon(address(logic), msg.sender);

        // Deploy the proxy
        ClaimProxy proxy = new ClaimProxy(address(beacon), abi.encodeWithSignature("initialize(address)", msg.sender));

        vm.stopBroadcast();
    }
}

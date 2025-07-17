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

contract DeployContractsWithWallet is Script {
    function run() external {
        vm.startBroadcast();

        DeployEarthWallet earthFactory = new DeployEarthWallet();

        //address earthFactoryAddress = earthFactory.getAddress(address(logic), 0);
        // Deploy the logic contract
        ClaimLogic logic = new ClaimLogic();

        // Deploy the beacon
        ClaimBeacon beacon = new ClaimBeacon(address(logic), msg.sender);

        // Deploy the proxy
        ClaimProxy proxy = new ClaimProxy(
            address(beacon), abi.encodeWithSignature("initialize(address,address)", msg.sender, address(earthFactory))
        );

        ClaimLogic claimLogic = ClaimLogic(address(proxy));

        // deploy the Earth Wallet from address with claimId 0
        address earthWalletAddress = earthFactory.deployEarth(address(claimLogic), 0);

        claimLogic.linkEarthWallet(earthWalletAddress);

        console.log("ClaimLogic Proxy deployed at:", address(proxy));
        console.log("Earth Wallet deployed at:", earthWalletAddress);

        //Depending on how it is written, can mint Earth here, and lock it so it's non-transferrable

        vm.stopBroadcast();
    }
}

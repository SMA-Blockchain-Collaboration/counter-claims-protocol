// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/ClaimLogic.sol";
import "@openzeppelin/contracts/proxy/beacon/UpgradeableBeacon.sol";
import "@openzeppelin/contracts/proxy/beacon/BeaconProxy.sol";

contract ClaimLogicTest is Test {
    ClaimLogic logic;
    ClaimLogic newLogic;
    UpgradeableBeacon beacon;
    BeaconProxy proxy;

    ClaimLogic proxyLogic;

    function setUp() public {
        // Deploy the initial implementation
        logic = new ClaimLogic();
        logic.initialize(address(this)); // Pass the test contract as the owner

        // Deploy the beacon with the initial implementation
        beacon = new UpgradeableBeacon(address(logic), address(this));

        // Deploy the proxy pointing to the beacon
        proxy = new BeaconProxy(
            address(beacon),
            abi.encodeWithSelector(
                ClaimLogic.initialize.selector,
                address(this)
            )
        );
        proxyLogic = ClaimLogic(address(proxy));
    }

    function testInitialize() public {
        // Verify initialization
        assertEq(proxyLogic.owner(), address(this));
    }

    function testMintClaim() public {
        // Mint a claim through the proxy
        proxyLogic.mintClaim("Title", "123.456,789.012", "Description");

        // Verify the claim details
        (
            address claimer,
            string memory title,
            string memory coordinates,
            string memory description
        ) = proxyLogic.claims(0);

        assertEq(claimer, address(this));
        assertEq(title, "Title");
        assertEq(coordinates, "123.456,789.012");
        assertEq(description, "Description");
    }

    function testUpgrade() public {
        // Deploy a new implementation
        newLogic = new ClaimLogic();

        // Upgrade the beacon
        beacon.upgradeTo(address(newLogic));

        // Verify the proxy points to the new implementation
        assertEq(beacon.implementation(), address(newLogic));
    }
}

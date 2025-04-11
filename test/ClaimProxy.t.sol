// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/ClaimLogic.sol";
import "../src/ClaimBeacon.sol";
import "../src/ClaimProxy.sol";

contract ClaimProxyTest is Test {
    ClaimLogic logic;
    ClaimBeacon beacon;
    ClaimProxy proxy;

    function setUp() public {
        logic = new ClaimLogic();
        beacon = new ClaimBeacon(address(logic), address(this));

        // Deploy proxy
        proxy = new ClaimProxy(address(beacon), "");
    }

    function testProxyDelegatesCall() public {
        // Call the logic via proxy
        ClaimLogic proxyLogic = ClaimLogic(address(proxy));
        proxyLogic.mintClaim("Proxy Place", "987.654,321.098", "A proxy place");

        // Assert: Verify state in the proxy
        (address claimer, string memory title, string memory coordinates, string memory description) =
            proxyLogic.claims(0);

        assertEq(claimer, address(this));
        assertEq(title, "Proxy Place");
        assertEq(coordinates, "987.654,321.098");
        assertEq(description, "A proxy place");
    }
}

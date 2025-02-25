// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "openzeppelin-contracts/contracts/access/Ownable.sol"; // Import OwnableUpgradeable
import "../src/ClaimLogic.sol";
import "../src/ClaimBeacon.sol";

contract ClaimBeaconTest is Test {
    ClaimLogic logic;
    ClaimLogic newLogic;
    ClaimBeacon beacon;

    function setUp() public {
        // Deploy initial implementation
        logic = new ClaimLogic();

        // Deploy beacon with initial implementation and owner
        beacon = new ClaimBeacon(address(logic), address(this));
    }

    function testInitialImplementation() public {
        // Assert: Initial implementation is set
        assertEq(beacon.implementation(), address(logic));
    }

    function testUpdateImplementation() public {
        // Arrange: Deploy new logic contract
        newLogic = new ClaimLogic();

        // Act: Update implementation as the owner
        beacon.upgradeTo(address(newLogic));

        // Assert: Implementation is updated
        assertEq(beacon.implementation(), address(newLogic));
    }

    function testUpdateImplementationFailsForNonOwner() public {
        // Arrange: Deploy new logic contract
        newLogic = new ClaimLogic();

        // Act & Assert: Expect the custom error from OpenZeppelin's Ownable
        vm.prank(address(0x1234)); // Simulate call from non-owner
        vm.expectRevert(
            abi.encodeWithSelector(
                OwnableUpgradeable.OwnableUnauthorizedAccount.selector, // Use the correct error
                address(0x1234)
            )
        );
        beacon.upgradeTo(address(newLogic));
    }
}

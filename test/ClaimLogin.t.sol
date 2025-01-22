// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/ClaimLogic.sol";

contract ClaimLogicTest is Test {
    ClaimLogic logic;

    function setUp() public {
        logic = new ClaimLogic();
    }

    function testMintClaim() public {
        // Act: Mint a claim
        logic.mintClaim("My Place", "123.456,789.012", "A beautiful place");

        // Assert: Verify claim details
        (
            address claimer,
            string memory title,
            string memory coordinates,
            string memory description
        ) = logic.claims(0);

        assertEq(claimer, address(this));
        assertEq(title, "My Place");
        assertEq(coordinates, "123.456,789.012");
        assertEq(description, "A beautiful place");
    }
}

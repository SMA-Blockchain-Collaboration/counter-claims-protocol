// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/ClaimLogic.sol";
import "../src/ClaimBeacon.sol";
import "../src/ClaimProxy.sol";

import IERC721Receiver from "openzeppelin-contracts/token/ERC721/IERC721Receiver.sol";

contract ClaimProxyTest is Test, IERC721Receiver {
    ClaimLogic logic;
    ClaimBeacon beacon;
    ClaimProxy proxy;

    function setUp() public {
        logic = new ClaimLogic();
        beacon = new ClaimBeacon(address(logic), address(this));

        // Deploy proxy
        proxy = new ClaimProxy(address(beacon), "");
    }

    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes calldata data
    ) external pure override returns (bytes4) {
        return IERC721Receiver.onERC721Received.selector;
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

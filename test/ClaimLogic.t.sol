// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/ClaimLogic.sol";
import "@openzeppelin/contracts/proxy/beacon/UpgradeableBeacon.sol";
import "@openzeppelin/contracts/proxy/beacon/BeaconProxy.sol";

import "openzeppelin-contracts/contracts/token/ERC721/IERC721Receiver.sol";

contract ClaimLogicTest is Test, IERC721Receiver {
    ClaimLogic logic;
    ClaimLogic newLogic;
    UpgradeableBeacon beacon;
    BeaconProxy proxy;

    ClaimLogic proxyLogic;

    //this test is causing an error
    function setUp() public {
        // Deploy the initial implementation
        logic = new ClaimLogic();

        // Deploy the beacon with the initial implementation
        beacon = new UpgradeableBeacon(address(logic), address(this));

        address secondClaimerWallet = address(0x456); 

        bytes memory initData = abi.encodeWithSelector(ClaimLogic.initialize.selector, address(this), secondClaimerWallet);

        // Deploy the proxy pointing to the beacon
        proxy = new BeaconProxy(address(beacon), initData);

        proxyLogic = ClaimLogic(address(proxy));
    }

    function testGasMint2Claims() public {
        // Optional: set a specific gas price for cost calculations
        vm.txGasPrice(8 gwei);

        uint256 gasStart = gasleft();

        // Call mint2Claims with realistic parameters
        claimLogic.mint2Claims("Test Title", "0,0", "Test Description");

        uint256 gasUsed = gasStart - gasleft();

        emit log_named_uint("Gas used", gasUsed);
        emit log_named_decimal_uint(
            "Cost in ETH",
            gasUsed * tx.gasprice,
            18
        );
    }
    
    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes calldata data
    ) external override returns (bytes4) {
        return this.onERC721Received.selector;
    }

    //warning here
    function testInitialize() public {
        // Verify initialization
        assertEq(proxyLogic.owner(), address(this));
    }

    function testMintClaim() public {
        // Mint a claim through the proxy
        proxyLogic.mintClaim("Title", "123.456,789.012", "Description");

        // Verify the claim details
        (address claimer, string memory title, string memory coordinates, string memory description) =
            proxyLogic.claims(1);

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

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "lib/openzeppelin-contracts-upgradeable/contracts/proxy/utils/Initializable.sol";
import "lib/openzeppelin-contracts-upgradeable/contracts/proxy/utils/UUPSUpgradeable.sol";
import "lib/openzeppelin-contracts-upgradeable/contracts/access/OwnableUpgradeable.sol";

contract ClaimLogic is Initializable, UUPSUpgradeable, OwnableUpgradeable {
    struct Claim {
        address claimer;
        string title;
        string coordinates;
        string description;
    }

    mapping(uint256 => Claim) public claims;
    uint256 public claimCounter;

    event ClaimMinted(
        uint256 indexed claimId,
        address indexed claimer,
        string title,
        string coordinates,
        string description
    );

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize(address initialOwner) public initializer {
        __Ownable_init(initialOwner); // Set the owner
        __UUPSUpgradeable_init(); // Initialize UUPSUpgradeable
    }

    function mintClaim(
        string memory title,
        string memory coordinates,
        string memory description
    ) public {
        require(bytes(title).length > 0, "Title cannot be empty");
        require(bytes(coordinates).length > 0, "Coordinates cannot be empty");
        require(bytes(description).length > 0, "Description cannot be empty");

        uint256 claimId = claimCounter;
        claims[claimId] = Claim({
            claimer: msg.sender,
            title: title,
            coordinates: coordinates,
            description: description
        });

        emit ClaimMinted(claimId, msg.sender, title, coordinates, description);
        claimCounter++;
    }

    function _authorizeUpgrade(
        address newImplementation
    ) internal override onlyOwner {}
}

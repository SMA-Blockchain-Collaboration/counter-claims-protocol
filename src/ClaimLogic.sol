// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "lib/openzeppelin-contracts-upgradeable/contracts/proxy/utils/Initializable.sol";
import "lib/openzeppelin-contracts-upgradeable/contracts/proxy/utils/UUPSUpgradeable.sol";
import "lib/openzeppelin-contracts-upgradeable/contracts/access/OwnableUpgradeable.sol";

import "./DeployEarthWallet.sol";

contract ClaimLogic is Initializable, UUPSUpgradeable, OwnableUpgradeable {
    struct Claim {
        address claimer;
        string title;
        string coordinates;
        string description;
    }

    mapping(uint256 => Claim) public claims;
    uint256 public claimCounter;
    Claim public earthClaim;
    uint256 public earthClaimId;
    address public earthWalletFactory;

    bool public isEarthClaimMinted = false;

    event ClaimMinted(
        uint256 indexed claimId, address indexed claimer, string title, string coordinates, string description
    );

    event EarthClaimMinted(
        uint256 indexed claimId, address indexed claimer, string title, string coordinates, string description
    );

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize(address initialOwner, address factoryAddress) public initializer {
        __Ownable_init(initialOwner); // Set the owner
        __UUPSUpgradeable_init(); // Initialize UUPSUpgradeable

        require(!isEarthClaimMinted, "Earth claim already exists");
        //if claimId or earthClaim or earthWalletAddress exists, then does not run code below

        string title = "";
        string coordinates = "";
        string description = "";
        claimId = claimCounter;

        //need to set claimer as either a contract, the blockchain, or sma account
        claims[claimId] = Claim({claimer: "", title: title, coordinates: coordinates, description: description});

        earthClaim = claims[claimId];
        earthClaimId = claimId;

        factory = factoryAddress;
        claimCounter++;
        emit EarthClaimMinted(title, coordinates, description);
    }

    function mintClaim(string memory title, string memory coordinates, string memory description) public {
        require(bytes(title).length > 0, "Title cannot be empty");
        require(bytes(coordinates).length > 0, "Coordinates cannot be empty");
        require(bytes(description).length > 0, "Description cannot be empty");

        uint256 claimId = claimCounter;
        claims[claimId] = Claim({claimer: msg.sender, title: title, coordinates: coordinates, description: description});

        emit ClaimMinted(claimId, msg.sender, title, coordinates, description);
        claimCounter++;
    }

    // mint two claims that have the same title, coordinates, and description
    // one of the claims goes to the user, while the other claim is held by the Earth claim
    function mint2Claims(string memory title, string memory coordinates, string memory description) public {
        require(bytes(title).length > 0, "Title cannot be empty");
        require(bytes(coordinates).length > 0, "Coordinates cannot be empty");
        require(bytes(description).length > 0, "Description cannot be empty");

        uint256 claimId = claimCounter;

        claims[claimId] = Claim({claimer: msg.sender, title: title, coordinates: coordinates, description: description});
        claims[claimId + 1] =
            Claim({claimer: earthWalletAddress, title: title, coordinates: coordinates, description: description});
        emit ClaimMinted(claimId, msg.sender, title, coordinates, description);
        emit ClaimMinted(claimId, earthWalletAddress, title, coordinates, description);
        claimCounter += 2;
    }

    function ownerOf(uint256 claimId) public view returns (address) {
        if (claimId = earthClaimId) {
            //if the claimId is the one of the claim held by the TBA, then cast earthWalletFactory to a DeployEarthWallet type
            //then return the getAddress to find the token's TBA account
            return DeployEarthWallet(earthWalletFactory).getAddress(address(this), claimId);
        }
        Claim storage claim = claims[claimId];
        return claim.claimer;
    }

    function getClaimer(uint256 claimId) external view returns (address) {
        return claims[claimId].claimer;
    }
    // checks to see if an Earth claim already exists. if so, then does not mint the earth claim.
    // otherwise, mints the earth claim with preset title, coordinates, and description
    //function mintEarth() public {
    //  require(!isEarthClaimMinted, "Earth claim already exists");
    //  //if claimId or earthClaim or earthWalletAddress exists, then does not run code below

    //  string title = "";
    //  string coordinates = "";
    //  string description = "";
    //  claimId = claimCounter;

    //  //need to set claimer as either a contract, the blockchain, or sma account
    //  claims[claimId] = Claim({claimer: "", title: title, coordinates: coordinates, description: description});
    //
    //  earthClaim = claims[claimId];
    //  earthClaimId = claimId;

    //  claimCounter++;
    //  emit EarthClaimMinted(title, coordinates, description)
    //}

    function _authorizeUpgrade(address newImplementation) internal override onlyOwner {}
}

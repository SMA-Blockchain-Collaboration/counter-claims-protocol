// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "lib/openzeppelin-contracts-upgradeable/contracts/token/ERC721/ERC721Upgradeable.sol";
import "lib/openzeppelin-contracts-upgradeable/contracts/proxy/utils/Initializable.sol";
import "lib/openzeppelin-contracts-upgradeable/contracts/proxy/utils/UUPSUpgradeable.sol";
import "lib/openzeppelin-contracts-upgradeable/contracts/access/OwnableUpgradeable.sol";

import "./DeployEarthWallet.sol";

contract ClaimLogic is Initializable, ERC721Upgradeable, UUPSUpgradeable, OwnableUpgradeable {
    struct Claim {
        address claimer;
        string title;
        string coordinates;
        string description;
    }

    mapping(uint256 => Claim) public claims;
    uint256 public claimCounter;

    //Earth specific variables
    Claim public earthClaim;
    uint256 public earthClaimId;
    address public earthWalletFactory;
    address public earthWalletAddress;
    bool public isEarthClaimMinted;

    //events that claims have been minted
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
        __ERC721_init("ClaimToken", "CLM");
        __UUPSUpgradeable_init(); // Initialize UUPSUpgradeable

        require(!isEarthClaimMinted, "Earth claim already exists");

        //if claimId or earthClaim or earthWalletAddress exists, then does not run code below
        string memory title = "Earth";
        string memory coordinates = "0,0";
        string memory description = "The root claim that represents the Earth";

        //need to set claimer as either a contract, the blockchain, or sma account
        claims[claimCounter] = Claim({claimer: initialOwner, title: title, coordinates: coordinates, description: description});
        _safeMint(initialOwner, claimCounter);

        earthClaim = claims[claimCounter];
        earthClaimId = claimCounter;
        earthWalletFactory = factoryAddress;
        isEarthClaimMinted = true;

        claimCounter++;
        isEarthClaimMinted = true;

        //need to set claimer as either a contract, the blockchain, or sma account
        emit EarthClaimMinted(earthClaimId, initialOwner, title, coordinates, description);
    }

    function _authorizeUpgrade(address newImplementation) internal override onlyOwner {}

    function mintClaim(string memory title, string memory coordinates, string memory description) public {
        require(bytes(title).length > 0, "Title cannot be empty");
        require(bytes(coordinates).length > 0, "Coordinates cannot be empty");
        require(bytes(description).length > 0, "Description cannot be empty");

        uint256 claimId = claimCounter;
        claims[claimId] = Claim({claimer: msg.sender, title: title, coordinates: coordinates, description: description});
        _safeMint(msg.sender, claimId);

        emit ClaimMinted(claimId, msg.sender, title, coordinates, description);
        claimCounter++;
    }

    // mint two claims that have the same title, coordinates, and description
    // one of the claims goes to the user, while the other claim is held by the Earth claim
    function mint2Claims(string memory title, string memory coordinates, string memory description) public {
        require(bytes(title).length > 0, "Title cannot be empty");
        require(bytes(coordinates).length > 0, "Coordinates cannot be empty");
        require(bytes(description).length > 0, "Description cannot be empty");
        require(earthWalletAddress != address(0), "Earth wallet not linked yet");

        uint256 claimId1 = claimCounter;
        uint256 claimId2 = claimCounter + 1;

        claims[claimId1] = Claim({claimer: msg.sender, title: title, coordinates: coordinates, description: description});
        claims[claimId2] = Claim({claimer: earthWalletAddress, title: title, coordinates: coordinates, description: description});

        _safeMint(msg.sender, claimId1);
        _safeMint(earthWalletAddress, claimId2);

        //emit that both claims have been minted
        emit ClaimMinted(claimId1, msg.sender, title, coordinates, description);
        emit ClaimMinted(claimId2, earthWalletAddress, title, coordinates, description);
        claimCounter += 2;
    }

    function linkEarthWallet(address walletAddress) external onlyOwner {
        require(earthWalletAddress == address(0), "Earth wallet already linked");
        earthWalletAddress = walletAddress;
    }

    function ownerOf(uint256 claimId) public view virtual override returns (address) {
        if (claimId == earthClaimId) {
            //if the claimId is the one of the claim held by the TBA, then cast earthWalletFactory to a DeployEarthWallet type
            //then return the getAddress to find the token's TBA account
            return DeployEarthWallet(earthWalletFactory).getAddress(address(this), claimId);
        }
        return super.ownerOf(claimId);
    }

    function getClaimer(uint256 claimId) external view returns (address) {
        return claims[claimId].claimer;
    }

    function getEarthWallet() external view returns (address) {
        return earthWalletAddress;
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        address owner = ownerOf(tokenId);

        Claim memory c = claims[tokenId];

        return string(
            abi.encodePacked(
                "data:application/json;utf8,{",
                '"name":"',
                c.title,
                '",',
                '"description":"',
                c.description,
                '",',
                '"attributes":[{"trait_type":"Coordinates","value":"',
                c.coordinates,
                '"}]',
                "}"
            )
        );
    }
}

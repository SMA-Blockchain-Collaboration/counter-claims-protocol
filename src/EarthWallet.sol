// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ClaimLogic"

interface IClaimLogic {
  function getClaimer(uint256 claimId) external view returns (address);
}

contract ClaimEarth { 
  address public immutable claimContract;
  uint256 public immutable claimId;

  constructor(address _claimContract, uint256 _claimId) {
    claimContract = _claimContract;
    claimId = _claimId;
  }

  // ensures only the owner of the claim/NFT can call functions of this contract (execute)
  modifier onlyClaimOwner() {
    require(msg.sender ==  IClaimLogic(claimContract).getClaimer(claimId), "Not claim owner");
    _;
  }

  // uses a low-level function (call) to support contract interactions and ETH transfers
  function execute(address to, uint256 value, bytes calldata data) external onlyNFT returns (bytes memory) {
    (bool success, bytes memory result) = to.call{value: value}(data);
    require(success, "Call failed");
    return result;
  }

  // allows contract to receive ETH directly
  receive() external payable {}

}

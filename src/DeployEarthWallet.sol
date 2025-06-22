// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./EarthWallet.sol";

// allows for the deployment of wallet-to-claim (1-1) pairs
// everything is in contract & claimId pairings. 
contract DeployEarthWallet {
  //event for potential The Graph indexing
  event DeployedEarthWallet(address account);

  //deploys the single Earth Claim wallet, and emits an event upon completion. 
  function deployEarth(address claimContract, uint256 claimId) external returns (address){
    bytes32 salt = keccak256(abi.encodePacked(claimContract, claimId));
    bytes memory bytecode = abi.encodePacked(
      type(EarthWallet).creationCode,
      abi.encode(claimContract, claimId)
    );
    
    address account;

    assembly {
      account := create2(0, add(bytecode, 32), mload(bytecode), salt)
      if iszero(account) { revert(0,0) }
    }

    emit DeployedEarthWallet(account)
    return account;
  }

  //predicts the address of the claim on the chain, without deploying it.
  //useful for systems that need to know the address in advance.
  function getAddress(address claimContract, uint256 claimId) public view returns (address){
    bytes32 salt = keccak256(abi.encodePacked(claimContract, claimId));
    bytes memory bytecode = abi.encodePacked(
      type(EarthWallet).creationCode,
      abi.encode(tokenContract, tokenId)
    )

    bytes32 hash = keccak256(abi.encodePacked(
      bytes1(0xff),
      address(this),
      salt,
      keccak256(bytecode)
    ));

    return address(uint160(uint256(hash)));
  }
}

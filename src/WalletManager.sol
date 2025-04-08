// SPDX-License-Identifier: MIT
// Manages user wallets, including those interacting with the protocol and "Earth" token account.
pragma solidity ^0.8.0;

import "lib/openzeppelin-contracts-upgradeable/contracts/proxy/utils/Initializable.sol";
import "lib/openzeppelin-contracts-upgradeable/contracts/proxy/utils/UUPSUpgradeable.sol";
import "lib/openzeppelin-contracts-upgradeable/contracts/access/OwnableUpgradeable.sol";

// We probably want to use a proxy contract 
contract WalletManager is Initializable, UUPSUpgradeable, OwnableUpgradeable {

    //initializes wallet for the user 
    function createWallet(address user) public {

    }

    //allows wallets to be exported
    function exportWallet(address user) public {

    }

    function _authorizeUpgrade(
        address newImplementation
    ) internal override onlyOwner {}
}

# Counter Claims Protocol

This repository contains the smart contracts for the **Counter Claims Protocol**, a system that allows users authenticated with a wallet to mint "Claims" on the blockchain. Each claim includes:
- The wallet address of the claimer
- The title of the place being claimed
- A set of geographic coordinates
- A description of the claim

## How This Project Uses the Beacon Proxy Pattern

The **Beacon Proxy Pattern** is an upgradeable smart contract architecture. It consists of three main components:
1. **Beacon Contract**: Stores the address of the current logic implementation.
2. **Proxy Contracts**: Lightweight contracts that delegate all calls to the logic implementation provided by the Beacon.
3. **Logic Implementation**: The smart contract that contains the actual functionality (e.g., minting claims).

### Why the Beacon Proxy Pattern?
The Beacon Proxy Pattern is used in this project to:
- Allow **multiple Claim instances** to share the same logic implementation, saving on deployment costs.
- Enable **easy upgrades** to the logic without redeploying individual Claim contracts.
- Maintain **unique data storage** for each Proxy Contract (e.g., individual claims).

### How It Works in This Project
1. A user interacts with a Proxy Contract.
2. The Proxy delegates all calls to the Logic Implementation via the Beacon.
3. The Beacon ensures all Proxies use the latest version of the Logic Implementation.

---

## Getting Started

Follow the steps below to set up the project locally.

### 1. Prerequisites
Ensure you have the following installed:
- [Foundry](https://book.getfoundry.sh/getting-started/installation.html): A smart contract development framework.
  To install Foundry, run:
  ```
  curl -L https://foundry.paradigm.xyz | bash
  foundryup
 ```

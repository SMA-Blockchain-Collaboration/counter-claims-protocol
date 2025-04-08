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

### Prerequisites
Ensure you have the following installed:
- [Foundry](https://book.getfoundry.sh/getting-started/installation.html): A smart contract development framework.
  - Install Foundry by running the following commands. NOTE:  If you’re using Windows, you’ll need to install and use Git BASH or WSL as your terminal, since Foundryup currently doesn’t support Powershell or Command Prompt (Cmd). Please click the link above for the manual:
    ```bash
    curl -L https://foundry.paradigm.xyz | bash
    foundryup
    ```
- Git

---

1. Clone the Repository
Clone this repository to your local machine:
```bash
git clone https://github.com/SMA-Blockchain-Collaboration/counter-claims-protocol.git
cd counter-claims-protocol
```

2. Initialize Submodules
This project uses Git submodules to manage dependencies (e.g., OpenZeppelin contracts). Initialize and update the submodules by running:

```bash
git submodule update --init --recursive
```

3. Install Foundry Dependencies
Install the necessary dependencies using forge:
```bash
forge install
```
4. Test the Project
Run the test suite to ensure everything is functioning correctly:
```bash
forge test
```

## Contributing
To contribute:

1. Create a feature branch:
```bash
git checkout -b feature/your-feature-name
```

2. Make your changes and write tests.
3. Push your branch and open a pull request.

## License
This project is licensed under the MIT License. See the LICENSE file for more details.

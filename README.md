# MUTATOKEN – Hardhat Mainnet Deployment (Oct 10, 2025)

This repository contains the production deployment of the MUTATOKEN smart contract on the BNB Smart Chain mainnet. It is built with the Hardhat framework and includes all contract code, deployment logic, test scripts, and more.

---

## 📜 Contract Info

- **Proxy address:** [`0x1E3cBe308888f55f7b18b718aAA838F65c2e58bc`](https://bscscan.com/address/0x1E3cBe308888f55f7b18b718aAA838F65c2e58bc)
- **Implementation address:** [`0xe785F2037fbC67bA1047CCa8966faEb1BEB07566`](https://bscscan.com/address/0xe785F2037fbC67bA1047CCa8966faEb1BEB07566)
- **Token name:** MUTERRA  
- **Symbol:** MUTA  
- **Decimals:** 18  
- **Total supply:** 1,000,000 MUTA  

---

## 📁 Project Structure

```
contracts/           # Solidity contracts  
flat/                # Flattened contracts for BscScan verification  
scripts/             # Deployment and interaction scripts  
test/                # Unit tests  
tasks/               # Custom CLI tasks  
ignition/            # Hardhat Ignition deployment modules  
typechain-types/     # Auto-generated TypeScript types  
```

---

## ⚙️ Setup

Install dependencies:

```bash
npm install
```

Compile contracts:

```bash
npx hardhat compile
```

---

## 🚀 Deploy to BNB Mainnet

Create a `.env` file in the root directory with your secrets:

```
PRIVATE_KEY=your_private_key
BSCSCAN_API_KEY=your_bscscan_api_key
```

Then deploy:

```bash
npx hardhat run scripts/deploy-upgradeable.ts --network bsc
```

---

## 🧪 Run Tests

```bash
npx hardhat test
```

---

## 🔍 Verify Contract

```bash
npx hardhat verify --network bsc <IMPLEMENTATION_ADDRESS>
```

---

## 🧼 Key Scripts

- `scripts/deploy-upgradeable.ts` – mainnet deployment  
- `scripts/upgrade.ts` – proxy upgrade  
- `scripts/getImplementation.ts` – get implementation from proxy  
- `scripts/test-actions.ts` – mint/burn simulation  
- `scripts/test-read.ts` – read values from blockchain  

---

## 📦 Tech Stack

- Solidity  
- TypeScript  
- Hardhat  
- OpenZeppelin  
- Hardhat Ignition  

---

## 📜 License

MIT
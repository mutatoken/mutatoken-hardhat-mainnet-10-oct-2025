import { ethers, upgrades } from "hardhat";

async function main() {
  const proxyAddress = "0x1E3cBe308888f55f7b18b718aAA838F65c2e58bc"; // <== Укажи адрес ПРОКСИ здесь
  const implementationAddress = await upgrades.erc1967.getImplementationAddress(proxyAddress);
  console.log("🧠 Implementation address:", implementationAddress);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
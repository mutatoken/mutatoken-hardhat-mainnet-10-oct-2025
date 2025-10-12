import { ethers, upgrades } from "hardhat";

async function main() {
  const proxyAddress = "0xd6b9B238572b50d807bB0837A35bA93fD48B2a82"; // <-- это твой текущий прокси-адрес

  const MUTERRA = await ethers.getContractFactory("MUTERRA");
  console.log("Upgrading MUTERRA...");

  await upgrades.upgradeProxy(proxyAddress, MUTERRA);

  console.log("Upgrade complete for proxy:", proxyAddress);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
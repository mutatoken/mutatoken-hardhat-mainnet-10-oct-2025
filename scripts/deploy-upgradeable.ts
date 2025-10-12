import { ethers, upgrades } from "hardhat";

async function main() {
  const [deployer] = await ethers.getSigners();

  console.log("🚀 Deploying contracts with account:", deployer.address);

  const MUTERRAFactory = await ethers.getContractFactory("MUTERRA");

  const owner = deployer.address;
  const treasury = deployer.address;

  const proxy = await upgrades.deployProxy(MUTERRAFactory, [owner, treasury], {
    initializer: "initialize",
  });

  await proxy.waitForDeployment();

  const proxyAddress = await proxy.getAddress();
  console.log("✅ MUTERRA proxy deployed to:", proxyAddress);
}

main().catch((error) => {
  console.error("❌ Deployment failed:", error);
  process.exitCode = 1;
});
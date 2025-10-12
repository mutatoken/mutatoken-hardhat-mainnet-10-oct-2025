import { ethers, upgrades } from "hardhat";

async function main() {
  const [deployer] = await ethers.getSigners();

  console.log("Deploying with address:", deployer.address);

  const MUTERRA = await ethers.getContractFactory("MUTERRA");
  const muta = await upgrades.deployProxy(MUTERRA, [deployer.address, deployer.address], {
    initializer: "initialize",
  });

  await muta.waitForDeployment();

  console.log("MUTERRA deployed to:", await muta.getAddress());
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
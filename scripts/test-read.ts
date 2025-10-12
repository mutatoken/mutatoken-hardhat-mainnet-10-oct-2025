import { ethers } from "hardhat";

async function main() {
  const proxyAddress = "0x0BE57c1744b48e825ad881FF35D63972D94cd9e9";
  const MUTERRA = await ethers.getContractAt("MUTERRA", proxyAddress);

  const name = await MUTERRA.name();
  console.log("✅ Token name:", name);

  const owner = await MUTERRA.owner();
  console.log("👑 Contract owner:", owner);
}

main().catch((error) => {
  console.error("❌ Error:", error);
  process.exitCode = 1;
});
import { ethers } from "hardhat";
import * as dotenv from "dotenv";
dotenv.config();

async function main() {
  const proxyAddress = "0x0BE57c7144b48e25ad881FF35D63972D94cd9e9"; // Твой прокси
  const provider = new ethers.providers.JsonRpcProvider("https://data-seed-prebsc-1-s1.binance.org:8545"); // BSC testnet

  const wallet = new ethers.Wallet(process.env.PRIVATE_KEY!, provider);
  const token = await ethers.getContractAt("MUTERRA", proxyAddress, wallet);

  console.log("👑 Owner:", wallet.address);

  // 🪙 Баланс ДО
  const balanceBefore = await token.balanceOf(wallet.address);
  console.log(`💰 Balance before mint: ${balanceBefore.toString()}`);

  // ✅ Mint
  const mintTx = await token.mint(wallet.address, ethers.utils.parseEther("100"));
  await mintTx.wait();
  console.log("✅ Minted 100 tokens!");

  // 🧾 Баланс ПОСЛЕ
  const balanceAfter = await token.balanceOf(wallet.address);
  console.log(`💳 Balance after mint: ${balanceAfter.toString()}`);

  // 🔥 Сжигание
  const burnTx = await token.burn(ethers.utils.parseEther("10"));
  await burnTx.wait();
  console.log("🔥 Burned 10 tokens!");

  // 📘 Финальный баланс
  const finalBalance = await token.balanceOf(wallet.address);
  console.log(`📘 Final Balance: ${finalBalance.toString()}`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
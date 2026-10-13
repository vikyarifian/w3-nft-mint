import { ethers } from "hardhat";

async function main() {
  console.log("Deploying CorporateBadge contract for corporate piagam digital...");

  const [deployer] = await ethers.getSigners();
  console.log("Deploying with account:", deployer.address);

  const balance = await ethers.provider.getBalance(deployer.address);
  console.log("Account balance:", ethers.formatEther(balance), "ETH");

  const CorporateBadge = await ethers.getContractFactory("CorporateBadge");

  // Workaround for Hardhat ethers address resolution limitation on custom network deployment
  const badge = await CorporateBadge.deploy();
  await badge.waitForDeployment();

  const contractAddress = await badge.getAddress();
  console.log("CorporateBadge deployed successfully to:", contractAddress);
  console.log("Initial MINTER_ROLE and DEFAULT_ADMIN_ROLE assigned to:", deployer.address);
}

main().catch((error) => {
  console.error("Deployment failed:", error);
  process.exitCode = 1;
});

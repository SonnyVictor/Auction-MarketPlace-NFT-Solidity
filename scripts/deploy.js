// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");

async function main() {
  // const currentTimestampInSeconds = Math.round(Date.now() / 1000);
  // const unlockTime = currentTimestampInSeconds + 60;
  // const lockedAmount = hre.ethers.parseEther("0.001");
  // const arbNFT = await hre.ethers.deployContract("ArbNFTAstronautClub");
  // await arbNFT.waitForDeployment();
  // console.log(await arbNFT.getAddress());

  // const nftTest = await hre.ethers.deployContract("TestNFT");
  // await nftTest.waitForDeployment();
  // console.log(await nftTest.getAddress());
  // const addressNFT = "0x398137aA0a094840972a1BCE91734B03125d436d";
  // const mkPlaceNFT = await hre.ethers.deployContract("ArbNFTMarketplace", [
  //   addressNFT,
  // ]);
  // await mkPlaceNFT.waitForDeployment();
  // console.log(await mkPlaceNFT.getAddress());

  const addressNFT = "0x398137aA0a094840972a1BCE91734B03125d436d";
  const auctionNFT = await hre.ethers.deployContract("AuctionNFT", [
    addressNFT,
  ]);
  await auctionNFT.waitForDeployment();
  console.log(await auctionNFT.getAddress());
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

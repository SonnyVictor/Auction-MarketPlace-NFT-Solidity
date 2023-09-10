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
  // const nft = "0x21e02De785De12eE13591fa80DC4e06A350415B4";
  // const lock = await hre.ethers.deployContract("arbNFTMarketPlaceListSellBuy", [
  //   nft,
  // ]);
  // await lock.waitForDeployment();
  // console.log(lock.target);
  // 0xA7eD1dEb29fd0B39E72026de4e0730Da103AD8E8
  // await hre.run("verify:verify", {
  //   address: lock.target,
  //   constructorArguments: [nft], // Pass constructor arguments if any
  // });
  // console.log("Contract verified:", lock.target);
  // const dataTime = await hre.ethers.deployContract("DateTime");
  // console.log("Contract verified:", dataTime.target);
  // await hre.run("verify:verify", {
  //   address: dataTime.target,
  // });
  // const tokenShiba = await hre.ethers.deployContract("TokenShiba");
  // console.log("Contract verified:", tokenShiba.target);
  // await hre.run("verify:verify", {
  //   address: tokenShiba.target,
  // });
  // token = IERC20(_token);
  // dateTimeContract = DateTime(_addressDateTime);
  // DateTime
  const token = "0xbcb24AFb019BE7E93EA9C43B7E22Bb55D5B7f45D";
  const dateTime = "0x3a9d64b0750c5e9eB44b73B0601059eC7229964D";
  const lockTokenBSCS = await hre.ethers.deployContract("LockTokenBSCS", [
    token,
    dateTime,
  ]);
  console.log("Contract verified:", lockTokenBSCS.target);
  // await hre.run("verify:verify", {
  //   address: lockTokenBSCS.target,
  //   constructorArguments: [token, dateTime],
  // });
  // Distribution
  // const contractDistribution = await hre.ethers.deployContract("Distribution");
  // console.log("address Contract", contractDistribution.target);
  // await hre.run("verify:verify", {
  //   address: contractDistribution.target,
  // });
  // Contract TokenShiba
  // const ArbNFTLuffy = await hre.ethers.deployContract("ArbNFTLuffy");
  // console.log("address Contract TokenShiba", ArbNFTLuffy.target);
  // await hre.run("verify:verify", {
  //   address: ArbNFTLuffy.target,
  // });
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

// Address DateTime:0x29b429b73d918896DB0eED1E298074F3143271F6
// Address TokenShiba:0xDD95628664658473D63bf609aA21E1802EC4836b
//

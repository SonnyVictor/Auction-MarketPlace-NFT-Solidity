const { ethers, JsonRpcProvider } = require("ethers");

const ABINFT = require("../ABINFT.json");

const addressNFT = "0x398137aA0a094840972a1BCE91734B03125d436d";

// async function mintNFT() {
//   const provider = new ethers.providers.JsonRpcProvider(
//     "https://polygon-mumbai.g.alchemy.com/v2/DWhj57hZthjfm9H69E-iTCNoHz5gUB24"
//   );

//   const privateKey = process.env.PRIVATE_KEY;

//   const wallet = new ethers.Wallet(privateKey, provider);

//   // Replace with your contract address and ABI
//   const contractAddress = "0x398137aA0a094840972a1BCE91734B03125d436d";
//   const contractABI = ABINFT;

//   const signer = provider.getSigner();

//   const contract = new ethers.Contract(contractAddress, contractABI, wallet);

//   try {
//     const tx = await contract.mint();
//     await tx.wait();

//     console.log("NFT minted successfully!");
//   } catch (error) {
//     console.error("Error minting NFT:", error);
//   }
// }
async function getGasLimit() {
  const provider = new ethers.providers.JsonRpcProvider(
    "https://polygon-mumbai.g.alchemy.com/v2/DWhj57hZthjfm9H69E-iTCNoHz5gUB24"
  );
  const blockNumber = await provider.getBlockNumber();
  const block = await provider.getBlock(blockNumber);
  const gasLimit = block.gasLimit / 18;

  console.log("Current gas limit:", gasLimit.toString());
}

getGasLimit();

// mintNFT();

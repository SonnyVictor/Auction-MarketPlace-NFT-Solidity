require("@nomicfoundation/hardhat-toolbox");

/** @type import('hardhat/config').HardhatUserConfig */
require("dotenv").config();
module.exports = {
  solidity: "0.8.19",

  networks: {
    // bsctest: {
    //   url: "https://data-seed-prebsc-1-s1.binance.org:8545",
    //   chainId: 97,
    //   accounts: [process.env.PRIVATE_KEY],
    // },

    bsc: {
      url: "https://bsc-dataseed.binance.org/",
      chainId: 56,
      accounts: [process.env.PRIVATE_KEY],
    },
  },
  etherscan: {
    // apiKey: process.env.KLAYTN_PRIVATE_KEY,
    // apiKey: process.env.POLYGONSCAN_API_KEY,
    apiKey: process.env.BNB_API_KEY,
  },
  // networks: {
  //   opbnb: {
  //     url: "https://opbnb-testnet-rpc.bnbchain.org/",
  //     chainId: 5611, // Replace with the correct chainId for the "opbnb" network
  //     accounts: [process.env.PRIVATE_KEY], // Add private keys or mnemonics of accounts to use
  //     gasPrice: 20000000000,
  //   },
  // },
  // etherscan: {
  //   apiKey: {
  //     opbnb: process.env.OPBNB_API_KEY, //replace your nodereal API key
  //   },
  // },
  // customChains: [
  //   {
  //     network: "opbnb",
  //     chainId: 5611, // Replace with the correct chainId for the "opbnb" network
  //     urls: {
  //       apiURL:
  //         "https://opbnb-testnet.nodereal.io/v1/752a9b9dd032492da8b585a548be07cf/op-bnb-testnet/contract/",
  //       browserURL: "https://opbnbscan.com/",
  //     },
  //   },
  // ],
};
// mumbai: {
//   url: process.env.TESTNET_RPC_MUMBAI,
//   accounts: [process.env.PRIVATE_KEY],
// },
// arbitrumGoerli: {
//   url: "https://arb-goerli.g.alchemy.com/v2/0c-W-wOb6hSGxIy1VxtRczrnrppZWmiK",
//   accounts: [process.env.PRIVATE_KEY],
// },
// baobab: {
//   url: process.env.KLAYTN_BAOBAB_URL || "",
//   chainId: 1001,
//   accounts:
//     process.env.PRIVATE_KEY !== undefined ? [process.env.PRIVATE_KEY] : [],
//   live: true,
//   saveDeployments: true,
// },



https://bscscan.com/address/0x3a9d64b0750c5e9eB44b73B0601059eC7229964D#readContract
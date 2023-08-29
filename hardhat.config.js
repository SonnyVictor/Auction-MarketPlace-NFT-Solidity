require("@nomicfoundation/hardhat-toolbox");

/** @type import('hardhat/config').HardhatUserConfig */
require("dotenv").config();
module.exports = {
  solidity: "0.8.19",

  networks: {
    // mumbai: {
    //   url: process.env.TESTNET_RPC_MUMBAI,
    //   accounts: [process.env.PRIVATE_KEY],
    // },
    // arbitrumGoerli: {
    //   url: "https://arb-goerli.g.alchemy.com/v2/0c-W-wOb6hSGxIy1VxtRczrnrppZWmiK",
    //   accounts: [process.env.PRIVATE_KEY],
    // },
    baobab: {
      url: process.env.KLAYTN_BAOBAB_URL || "",
      chainId: 1001,
      accounts:
        process.env.PRIVATE_KEY !== undefined ? [process.env.PRIVATE_KEY] : [],
      live: true,
      saveDeployments: true,
    },
  },
  etherscan: {
    apiKey: process.env.KLAYTN_PRIVATE_KEY,
    // apiKey: process.env.POLYGONSCAN_API_KEY,
  },
};

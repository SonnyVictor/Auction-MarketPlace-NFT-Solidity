require("@nomicfoundation/hardhat-toolbox");

/** @type import('hardhat/config').HardhatUserConfig */
require("dotenv").config();
// const { ALCHEMY_API_KEY, SEPOLIA_PRIVATE_KEY, ETHERSCAN_API_KEY } = process.env;
module.exports = {
  solidity: {
    compilers: [
      {
        version: "0.8.0",
      },
      {
        version: "0.8.15",
        settings: {},
      },
    ],
  },
  networks: {
    arbitrumGoerli: {
      url: "https://arb-goerli.g.alchemy.com/v2/YuLIDxmtnQ6FAWrnbTlItQe_fzFBjkQC",
      accounts: [process.env.PRIVATE_KEY],
    },
    // mumbai: {
    //   url: process.env.TESTNET_RPC_MUMBAI,
    //   accounts: [process.env.PRIVATE_KEY],
    // },
  },
  etherscan: {
    apiKey: process.env.ARB_API_KEY,
    // apiKey: process.env.POLYGONSCAN_API_KEY,
  },
};

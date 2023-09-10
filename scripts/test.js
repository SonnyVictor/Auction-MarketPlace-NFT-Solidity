const { ethers, WebSocketProvider } = require("ethers");
const _ABI = require("../ABI.json");

const { Network, Alchemy, AssetTransfersCategory } = require("alchemy-sdk");

const test = async () => {
  const wsurl =
    "wss://arb-goerli.g.alchemy.com/v2/YuLIDxmtnQ6FAWrnbTlItQe_fzFBjkQC";

  const contractAddress = "0x35EC4B2F55990536bae36f2268E3404C2993a351";
  var wsProvider = new WebSocketProvider(wsurl);

  let contract = new ethers.Contract(contractAddress, _ABI, wsProvider);
  const eventName = "BuyNFT";

  // const filter = contract.filters.BuyNFT([
  //   "0x5d963241241cfe9e161d13500d628058954b3febfde03e4b1f4071370e72fe2b",
  // ]);

  const filter = contract.filters.BuyNFT();
  const events = await contract.queryFilter(filter);

  console.log("EVENT", events);

  const settings = {
    apiKey: "YuLIDxmtnQ6FAWrnbTlItQe_fzFBjkQC", // Replace with your Alchemy API Key.
    network: Network.ARB_GOERLI, // Replace with your network.
  };
  const alchemy = new Alchemy(settings);

  // const curr = alchemy.core.getBlockNumber().then(console.log);
  // const startBlock = 34842200;

  // GetTransaction
  // const provider = new ethers.providers.Web3Provider(wsurl);
  // const history = await provider.getHistory(
  //   "0x6A292cacEfaD3d1898184379f428ac9fd61a7804"
  // );
  // console.log(history);
  // const data = await alchemy.core.getAssetTransfers({
  //   fromBlock: "0x0",
  //   toAddress: "0x35EC4B2F55990536bae36f2268E3404C2993a351",
  //   fromAddress: "0x6A292cacEfaD3d1898184379f428ac9fd61a7804",
  //   contractAddress: ["0x35EC4B2F55990536bae36f2268E3404C2993a351"],
  //   category: [AssetTransfersCategory.EXTERNAL, AssetTransfersCategory.ERC721],
  // });

  // console.log(data);
  //

  //   const filet = contract.filters.eventName();

  // const getLocks = await alchemy.core.getLogs({
  //   address: contractAddress,
  //   topics: [
  //     "0xd95631535651c70a1497fec4877e22850d2cf9fc99e31ade6bbe4c0bfa241f29",
  //   ],
  // });

  //   console.log(getLocks);
  // alchemy.core
  //   .getLogs({
  //     fromBlock: startBlock,
  //     toBlock: curr,
  //     address: "0x35EC4B2F55990536bae36f2268E3404C2993a351",
  //     topics: [
  //       "0xd95631535651c70a1497fec4877e22850d2cf9fc99e31ade6bbe4c0bfa241f29",
  //     ],
  //     //   blockHash:
  //     //     "0xa3110f4adfdaac347f1671bc6f4c62e8759e3f41e7d85fd28ff8fbb3239f8d89",
  //   })
  //   .then(console.log());
  const endBlock = 35325663;
  const allEvents = [];

  // const _endBlock = curr;
  const _startBLock = 34842200;
  //   const events = contract.queryFilter(eventName, [35273160, [35320644]]);

  // for (let i = startBlock; i < endBlock; i += 5000) {
  //   const _startBlock = i;
  //   const _endBlock = Math.min(endBlock, i + 4999);
  //   const events = await contract.queryFilter(
  //     eventName,
  //     _startBlock,
  //     _endBlock
  //   );
  //   // allEvents = [...allEvents, ...events];

  //   console.log(events);
  // }

  // const etherScan = new ethers.EtherscanProvider(Network.ARB_GOERLI);
  // const walletAddress = "0x6A292cacEfaD3d1898184379f428ac9fd61a7804";
  // const history = await etherScan.fetch("account", {
  //   address: walletAddress,
  //   action: "Buy Nft",
  // });

  // console.log(history);

  // for (let i = 34842200; i < curr; i += 5000) {
  //   const _startBlock = i;
  //   const _endBlock = Math.min(curr, i + 4999);
  //   const events = await contract.queryFilter(
  //     eventName,
  //     _startBlock,
  //     _endBlock
  //   );
  //   // allEvents = [...allEvents, ...events];

  //   console.log(events);
  // }

  // const data = await alchemy.core.getAssetTransfers({
  //   fromBlock: "0x0",
  //   toBlock: "latest",
  //   contractAddresses: ["0x21e02De785De12eE13591fa80DC4e06A350415B4"],
  //   excludeZeroValue: true,
  //   category: ["erc721"],
  // });
  // console.log(data.transfers[0]);

  // const dataTest = await alchemy.core.getTransactionReceipts({
  //   blockHash:
  //     "0x6881e09469565c4c23d540167b7a0f24548ebb4bbfc4d3c7b6e49f955e47ee10",
  // });
  // console.log(dataTest.receipts[1].logs[0].topics);
  // const walletAddress = "0x6A292cacEfaD3d1898184379f428ac9fd61a7804";

  // const transactionCount = await wsProvider.getTransactionCount(walletAddress);
  // const transactions = [];
  // for (let i = 0; i < transactionCount; i += 25) {
  //   const history = await wsProvider.getHistory(walletAddress, i, i + 25);
  //   transactions.push(...history);
  // }

  // console.log("Danh sách giao dịch:", transactions);

  const address = ["0x21e02de785de12ee13591fa80dc4e06a350415b4"];
  const dataActivityUser = await alchemy.core.getAssetTransfers({
    fromBlock: "0x0",
    contractAddresses: address,
    category: [AssetTransfersCategory.ERC721],
    excludeZeroValue: false,
  });
  console.log(dataActivityUser.transfers);
  let txns = dataActivityUser.transfers.filter(
    (txn) => fromHex(txn.erc721TokenId) === Number(id)
  );
  console.log("TXNS", txns);
  const items = await Promise.all(
    txns.map(async (i) => {
      const [transactionHash, , logIndexStr] = i.uniqueId.split(":");
      const logIndex = parseInt(logIndexStr);

      try {
        const txReceipt = await provider.getTransactionReceipt(transactionHash);

        if (txReceipt && txReceipt.logs.length > logIndex) {
          const log = txReceipt.logs[logIndex];
          const parsedLog = contractNFT.interface.parseLog(log);
          return parsedLog;
        }
      } catch (error) {}
    })
  );
};
test();

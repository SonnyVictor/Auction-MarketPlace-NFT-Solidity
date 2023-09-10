const { MerkleTree } = require("merkletreejs");
const keccak256 = require("keccak256");

const whitelist = [
  "0xdD870fA1b7C4700F2BD7f44238821C26f7392148",
  "0x583031D1113aD414F02576BD6afaBfb302140225",
  "0x4B0897b0513fdC7C541B6d9D7E929C4e5364D2dB",
  "0x14723A09ACff6D2A60DcdF7aA4AFf308FDDC160C",
  "0xCA35b7d915458EF540aDe6068dFe2F44E8fa733c",
  "0x0A098Eda01Ce92ff4A4CCb7A4fFFb5A43EBC70DC",
  "0x1aE0EA34a72D944a8C7603FfB3eC30a6669E454C",
  "0x03C6FcED478cBbC9a4FAB34eF9f40767739D1Ff7",
];

const leaves = whitelist.map((addr) => keccak256(addr));
const merkleTree = new MerkleTree(leaves, keccak256, { sortPairs: true });
const rootHash = merkleTree.getRoot().toString("hex");
console.log(`Whitelist Merkle Root: 0x${rootHash}`);
whitelist.forEach((address) => {
  const proof = merkleTree.getHexProof(keccak256(address));
  console.log(`Adddress: ${address} Proof: ${proof}`);
});

// Root :0xe8180d703dba67bcaf42b4d11b7b055f32913ede5ac77e919c99aee49d2c2261

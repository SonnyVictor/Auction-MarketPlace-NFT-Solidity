// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

contract Whitelist {
    bytes32 public merkleRoot;

    constructor(bytes32 _merkleRoot) {
        merkleRoot = _merkleRoot;
    }

    function checkInWhitelist(
        bytes32[] calldata proof,
        uint64 maxAllowanceToMint
    ) public view returns (bool) {
        bytes32 leaf = keccak256(abi.encode(msg.sender, maxAllowanceToMint));
        bool verified = MerkleProof.verify(proof, merkleRoot, leaf);
        return verified;
    }
}


0x304e964DdbAa4517118d1d7D500b773998374B63

0x3d669a45eDAaeA60dC979613aEf24A306DC9994f


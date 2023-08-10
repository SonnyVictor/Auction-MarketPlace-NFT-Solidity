const {
  time,
  loadFixture,
} = require("@nomicfoundation/hardhat-toolbox/network-helpers");
const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Auction Contract ", function () {
  async function deployTokenFixture() {
    const [owner, addr1, addr2, addr3, addr4, addr5] =
      await ethers.getSigners();

    // ContractNFT
    const NFTTest = await ethers.deployContract("TestNFT");
    await NFTTest.waitForDeployment();

    // ContractAuction
    const auctionNFT = await ethers.deployContract("AuctionNFT", [
      NFTTest.target,
    ]);
    await auctionNFT.waitForDeployment();

    return { NFTTest, auctionNFT, owner, addr1, addr2, addr3, addr4, addr5 };
  }

  describe("Deployment", function () {
    it("Mint NFT and check tokenID", async function () {
      const { NFTTest, auctionNFT, owner, addr1, addr2, addr3, addr4, addr5 } =
        await loadFixture(deployTokenFixture);

      await NFTTest.connect(owner).mint();
      await NFTTest.connect(owner).approve(auctionNFT.target, 1);

      const moneyInit = ethers.parseEther("1");
      await auctionNFT.connect(owner).startNFTAuction(1, moneyInit, 9999);

      const auctionId = 0; // Assuming this is the first auction

      // Khoi tao 1
      await auctionNFT.connect(addr1).participateAution(0, {
        value: ethers.parseEther("1"),
      });
      const auctionInfo1 = await auctionNFT.getAuction(auctionId);
      console.log("Gia Khoi Tao", auctionInfo1[3].toString());
      console.log("previousBidder", auctionInfo1[4].toString());
      console.log("Gia lastBid", auctionInfo1[5].toString());
      console.log("Address lastBidder", auctionInfo1[6].toString());

      // Dau gia lan 2
      await auctionNFT.connect(addr2).participateAution(0, {
        value: ethers.parseEther("1.05"),
      });
      const auctionInfo2 = await auctionNFT.getAuction(auctionId);
      console.log("////////////////////////");
      console.log("Gia Khoi Tao", auctionInfo2[3].toString());
      console.log("previousBidder", auctionInfo2[4].toString());
      console.log("Gia lastBid", auctionInfo2[5].toString());
      console.log("Address lastBidder", auctionInfo2[6].toString());

      // Dau Gia lan 3
      await auctionNFT.connect(addr3).participateAution(0, {
        value: ethers.parseEther("1.1025"),
      });
      const auctionInfo3 = await auctionNFT.getAuction(auctionId);
      console.log("////////////////////////");
      console.log("Gia Khoi Tao", auctionInfo3[3].toString());
      console.log("previousBidder", auctionInfo3[4].toString());
      console.log("Gia lastBid", auctionInfo3[5].toString());
      console.log("Address lastBidder", auctionInfo3[6].toString());

      console.log(auctionInfo3.toString());

      // expect(auctionInfo.initialPrice).to.equal(moneyInit);
      // console.log(joinAuction2);

      // const approveNFT = await NFTTest.approve(auctionNFT.target, 1);
      // console.log(approveNFT);
    });

    // it("Should user mint NFT", async function () {
    //   const { arbNFT, owner, otherAccount } = await loadFixture(
    //     deployArbNFTAstronautClub
    //   );
    //   await arbNFT.connect(otherAccount).mint({
    //     value: ethers.parseEther("0.009"),
    //   });
    // });
  });
});

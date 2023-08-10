// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/Address.sol";

contract AuctionNFT is IERC721Receiver, Ownable, ReentrancyGuard {
    using SafeMath for uint256;
    using Counters for Counters.Counter;
    using Address for address payable;
    Counters.Counter private _auctionIds;

    IERC721 private nft;

    uint256 private feeService = 5;
    uint256 private lawAuction = 5;
    bool private paused;

    address private serviceAddress;

    constructor(IERC721 _nft) {
        nft = _nft;
        serviceAddress = owner();
    }

    struct InfoAuction {
        uint256 idAuction;
        // Info Auction
        uint256 _tokenId;
        address auctioneer;
        uint256 initialPrice;
        //
        address previousBidder;
        //
        uint256 lastBid;
        address lastBidder;
        // Time
        uint256 startTime;
        uint256 endTime;
        //
        bool isSold;
        bool currentlyListed;
    }

    InfoAuction[] private auction;

    event SetNFT(IERC721 _nft);
    event StartAuction(
        uint256 indexed idAuction,
        uint256 tokenId,
        address auctioneer,
        uint256 initialPrice,
        uint256 startTime,
        uint256 endTime
    );
    event ParticipateAution(
        uint256 indexed idAuction,
        address sender,
        uint256 amountAuction
    );
    event FinishAuction(address indexed lastBidder, uint256 amount);
    event CancelAuction(uint256 cancelAuction);

    function setAddressNFT(IERC721 _nft) external onlyOwner {
        nft = _nft;
        emit SetNFT(_nft);
    }

    function startNFTAuction(
        uint256 _tokenId,
        uint256 _initPrice,
        uint256 _duration
    ) external {
        require(paused == false, "Contract is paused");
        uint256 idAuction = _auctionIds.current();
        require(_initPrice > 0, "Initial price must be greater than 0");
        // NFT
        require(
            nft.ownerOf(_tokenId) == msg.sender,
            "Must stake your own token"
        );
        require(
            nft.getApproved(_tokenId) == address(this),
            "This contract must be approved to transfer the token"
        );

        nft.safeTransferFrom(msg.sender, address(this), _tokenId);
        InfoAuction memory _auction = InfoAuction(
            idAuction,
            _tokenId,
            msg.sender,
            _initPrice,
            address(0),
            0,
            address(0),
            block.timestamp,
            block.timestamp.add(_duration),
            false,
            true
        );

        auction.push(_auction);
        emit StartAuction(
            idAuction,
            _tokenId,
            msg.sender,
            _initPrice,
            block.timestamp,
            block.timestamp.add(_duration)
        );
    }

    function participateAution(
        uint256 _idAuction
    ) external payable nonReentrant {
        InfoAuction storage _auction = auction[_idAuction];

        require(
            _auction.auctioneer != msg.sender,
            "Can not bid on your own auction"
        );

        require(
            block.timestamp >= _auction.startTime,
            "Auction already started"
        );
        require(block.timestamp <= _auction.endTime, "Auction already ended");
        require(_auction.isSold == false, "Auction already sold");
        require(_auction.currentlyListed == true, "Auction already liseted");

        // cao hon 5%
        uint256 _minBid = _auction.lastBidder == address(0)
            ? _auction.initialPrice
            : calculateNewBid(_auction.lastBid, lawAuction);
        require(
            _minBid <= msg.value,
            "Bid price must be greater than the minimum price"
        );

        uint256 _lastBid = _auction.previousBidder == address(0)
            ? _auction.initialPrice + calculatePercentage(msg.value, lawAuction)
            : calculateReturnAmount(_auction.lastBid) +
                calculatePercentage(msg.value, lawAuction);

        // transfer Money
        if (_auction.lastBidder != address(0)) {
            bool sentForCreator = payable(_auction.lastBidder).send(_lastBid);
            require(sentForCreator, "Failed to send Ether creator");
        }
        _auction.previousBidder = _auction.lastBidder;
        _auction.lastBidder = msg.sender;
        _auction.lastBid = msg.value;

        if (block.timestamp >= _auction.endTime - 5 minutes) {
            _auction.endTime += 5 minutes;
        }
        emit ParticipateAution(_idAuction, msg.sender, msg.value);
    }

    event Test(uint256 amount);

    function finishAuction(
        uint256 _auctionId
    ) external payable nonReentrant onlyAuctioneer(_auctionId) {
        require(auction[_auctionId].isSold == false, "Auction is already sold");
        require(
            auction[_auctionId].currentlyListed == true,
            "Auction is not active"
        );

        // Transfer NFT to winner which is the last bidder
        nft.safeTransferFrom(
            address(this),
            auction[_auctionId].lastBidder,
            auction[_auctionId]._tokenId
        );

        uint256 lastBid = auction[_auctionId].lastBid;
        uint256 auctionServiceFee = calculatePercentage(lastBid, feeService);

        uint256 auctioneerReceive = lastBid.sub(auctionServiceFee * 2);

        bool sentForAuctioneer = payable(serviceAddress).send(
            auctionServiceFee
        );
        require(sentForAuctioneer, "Failed to send Ether sentForAuctioneer");

        bool sentForWalletOwner = payable(auction[_auctionId].auctioneer).send(
            auctioneerReceive
        );
        require(sentForWalletOwner, "Failed to send Ether sentForWalletOwner");

        auction[_auctionId].isSold = true;
        auction[_auctionId].currentlyListed = false;
        emit FinishAuction(auction[_auctionId].lastBidder, auctioneerReceive);
        emit Test(auctioneerReceive);
    }

    function cancelAuction(
        uint256 _auctionId
    ) external onlyAuctioneer(_auctionId) {
        require(
            auction[_auctionId].isSold == false,
            "Auction is already completed"
        );
        require(auction[_auctionId].currentlyListed, "Auction is not active");
        require(
            auction[_auctionId].lastBidder == address(0),
            "Auction cant cancel,Bidder already"
        );
        // Return NFT back to auctioneer
        nft.safeTransferFrom(
            address(this),
            auction[_auctionId].auctioneer,
            auction[_auctionId]._tokenId
        );
        auction[_auctionId].isSold = true;
        auction[_auctionId].currentlyListed = false;

        emit CancelAuction(_auctionId);
    }

    function calculatePercentage(
        uint256 amount,
        uint256 percentage
    ) private pure returns (uint256) {
        return (amount.mul(percentage)).div(100);
    }

    function calculateNewBid(
        uint256 oldBid,
        uint256 increasePercentage
    ) private pure returns (uint256) {
        return (oldBid.mul(100 + increasePercentage)).div(100);
    }

    function calculateReturnAmount(
        uint256 oldBid
    ) private view returns (uint256) {
        uint256 returnPercentage = 100 - lawAuction;
        return (oldBid * returnPercentage) / 100;
    }

    function withDraw() external payable onlyOwner {
        uint256 _amount = address(this).balance;
        bool sent = payable(msg.sender).send(_amount);
        require(sent, "Failed to send Ether");
    }

    // View For Front-end
    function setFeeBider(uint256 _setfeeBider) external onlyOwner {
        feeService = _setfeeBider;
    }

    function getFeeService() external view returns (uint256) {
        return feeService;
    }

    function setLawAuction(uint256 _setfeeBider) external onlyOwner {
        lawAuction = _setfeeBider;
    }

    function getLawAuction() external view returns (uint256) {
        return lawAuction;
    }

    function getAuction(
        uint256 _auctionId
    ) external view returns (InfoAuction memory) {
        return auction[_auctionId];
    }

    function getAllAuction() external view returns (InfoAuction[] memory) {
        InfoAuction[] memory allValues = new InfoAuction[](auction.length);
        for (uint256 i = 0; i < auction.length; i++) {
            allValues[i] = auction[i];
        }
        return allValues;
    }

    function getInfoAuction(
        bool _active
    ) external view returns (InfoAuction[] memory) {
        uint256 length;
        for (uint i = 0; i < auction.length; i++) {
            if (auction[i].isSold == _active) {
                length++;
            }
        }
        InfoAuction[] memory results = new InfoAuction[](length);
        uint j = 0;
        for (uint256 index = 0; index < auction.length; index++) {
            if (auction[index].isSold == _active) {
                results[j] = auction[index];
                j++;
            }
        }
        return results;
    }

    function setPaused(bool _paused) external onlyOwner {
        paused = _paused;
    }

    function getPaused() external view returns (bool) {
        return paused;
    }

    function setServiceAddress(address _addr) external onlyOwner {
        serviceAddress = _addr;
    }

    function getServiceAddress() external view returns (address) {
        return serviceAddress;
    }

    modifier onlyAuctioneer(uint256 _auctionId) {
        require(
            (msg.sender == auction[_auctionId].auctioneer ||
                msg.sender == owner()),
            "Only auctioneer or owner can perform this action"
        );
        _;
    }

    function onERC721Received(
        address,
        address,
        uint256,
        bytes calldata
    ) external pure override returns (bytes4) {
        return
            bytes4(
                keccak256("onERC721Received(address,address,uint256,bytes)")
            );
    }
}

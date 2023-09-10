// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MarketplaceARB is Ownable {
    using EnumerableSet for EnumerableSet.AddressSet;
    using SafeERC20 for IERC20;
    using Counters for Counters.Counter;

    struct Order {
        address seller;
        address buyer;
        uint256 tokenId;
        address paymentToken;
        uint256 price;
        address nftAddress;
        uint256 startTime;
        uint256 endTime;
    }

    EnumerableSet.AddressSet private _supportedPaymentTokens;
    //IERC721 public immutable nftContract;
    uint256 public feeDecimal;
    uint256 public feeRate;
    address public feeRecipient;
    Counters.Counter private _orderIdCount;

    uint256 public feeDecimalCreator;
    uint256 public feeRateCreator;

    mapping(uint256 => Order) public orders;
    mapping(address => bool) public nftForSales;
    mapping(address => address) public creatorOfNFT;

    event AddPaymentToken(address paymentToken);
    event AddNFTForSale(address nftAddress, address creator);
    event RemoveNFTForSale(address nftAddress);
    event OrderAdded(
        uint256 indexed orderId,
        address indexed seller,
        uint256 indexed tokenId,
        address paymentToken,
        uint256 price,
        address nftAddress,
        uint256 startTime,
        uint256 endTime
    );
    event PriceUpdated(uint256 indexed orderId, uint256 price);
    event OrderCancelled(uint256 indexed orderId);
    event OrderMatched(
        uint256 indexed orderId,
        address indexed seller,
        address indexed buyer,
        uint256 tokenId,
        address paymentToken,
        uint256 price
    );
    event MakeOffer(uint256 orderId, address buyer, uint256 price);
    event feeRateUpdated(uint256 feeDecimal, uint256 feeRate);
    event feeRateCreatorUpdated(uint256 feeDecimal, uint256 feeRate);
    event AddOrderAuction(uint256 auctionId, address nftAddress, uint256 tokenId, address paymentToken, uint256 startBlock, uint256 endBlock, address seller, uint256 minPrice);
    event CancelAuction(uint256 auctionId);
    event BidPlaced(uint256 auctionId, address buyer, uint256 highest);
    event WithdrawAuction(uint256 auctionId, address paymentToken, uint256 amount);
    event AuctionEnded(address highestBidder, uint256 amount);

    modifier onlySupportedPaymentToken(address paymentToken_) {
        require(
            isPaymentTokenSupported(paymentToken_),
            "NFTMarketplace: unsupport payment token"
        );
        _;
    }

    modifier canExecute(
        uint256 orderId_,
        address buyer_,
        uint256 price_
    ) {
        require(
            orders[orderId_].seller != buyer_,
            "NFTMarketplace: buyer must be different from seller"
        );
        require(
            orders[orderId_].buyer == address(0),
            "NFTMarketplace: buyer must be zero"
        );
        require(
            price_ == orders[orderId_].price,
            "NFTMarketplace: price has been changed"
        );
        _;
    }

    function addNFTForSales( address nftAddress_, address creator_) external onlyOwner {
        require(nftAddress_ != address(0), "NFTMarketplace: nftAddress_ is zero address");
        nftForSales[nftAddress_] = true;
        creatorOfNFT[nftAddress_] = creator_;
        emit AddNFTForSale(nftAddress_, creator_);
    }

    function updateCreatorForNFTCollection( address nftAddress_, address creator_) external onlyOwner {
        require(nftAddress_ != address(0), "nftAddress_ is zero address");
        require(creator_ != address(0), "creator_ is zero address");
        require(nftForSales[nftAddress_], "NFT don't exist on marketplace");
        creatorOfNFT[nftAddress_] = creator_;
        emit AddNFTForSale(nftAddress_, creator_);
    }

    function removeNFTForSales(address nftAddress_) external onlyOwner {
        nftForSales[nftAddress_] = false;
        emit RemoveNFTForSale(nftAddress_);
    }

    function _calculateFee(uint256 orderId_) private view returns (uint256) {
        Order storage _order = orders[orderId_];
        if (feeRate == 0) {
            return 0;
        }
        return (feeRate * _order.price) / 10**(feeDecimal + 2);
    }

    function updateFeeRate(uint256 feeDecimal_, uint256 feeRate_) external  {
        require(
            feeRate_ < 10**(feeDecimal_ + 2),
            "NFTMarketplace: bad fee rate"
        );
        feeDecimal = feeDecimal_;
        feeRate = feeRate_;
        emit feeRateUpdated(feeDecimal_, feeRate_);
    }

    function updateFeeRateForCreator(uint256 feeDecimal_, uint256 feeRate_) external  {
    require(
        feeRate_ < 10**(feeDecimal_ + 2),
        "NFTMarketplace: bad fee rate"
    );
    feeDecimalCreator = feeDecimal_;
    feeRateCreator = feeRate_;
    emit feeRateCreatorUpdated(feeDecimal_, feeRate_);
    }

    function _calculateFeeCreator(uint256 orderId_) private view returns (uint256) {
        Order storage _order = orders[orderId_];
        if (feeRateCreator == 0) {
            return 0;
        }
        return (feeRate * _order.price) / 10**(feeDecimalCreator + 2);
    }

    function updateFeeRecipient(address feeRecipient_) external onlyOwner {
        require(
            feeRecipient_ != address(0),
            "NFTMarketplace: feeRecipient_ is zero address"
        );
        feeRecipient = feeRecipient_;
    }

    function addPaymentToken(address paymentToken_) external onlyOwner {
        require(
            paymentToken_ != address(0),
            "NFTMarketplace: feeRecipient_ is zero address"
        );
        require(
            _supportedPaymentTokens.add(paymentToken_),
            "NFTMarketplace: already supported"
        );
        emit AddPaymentToken(paymentToken_);
    }

    function isPaymentTokenSupported(address paymentToken_)
        public
        view
        returns (bool)
    {
        return _supportedPaymentTokens.contains(paymentToken_);
    }

    function addOrder(
        address nftAddress_,
        uint256 tokenId_,
        address paymentToken_,
        uint256 price_,
        uint256 endTime_
    ) external onlySupportedPaymentToken(paymentToken_) {
        require(nftForSales[nftAddress_], "NFTAddress nonexits!");
        require(
            IERC721(nftAddress_).ownerOf(tokenId_) == _msgSender(),
            "sender is not owner of token"
        );
        require(
            IERC721(nftAddress_).getApproved(tokenId_) == address(this) ||
                IERC721(nftAddress_).isApprovedForAll(_msgSender(), address(this)),
            "NFTMarketplace: The contract is unauthorized to manage this token"
        );
        require(price_ > 0, "NFTMarketplace: price must be greater than 0");
        require(endTime_ >= block.timestamp, "endTime is wrong!");
        uint256 _orderId = _orderIdCount.current();
        Order storage _order = orders[_orderId];
        _order.seller = _msgSender();
        _order.tokenId = tokenId_;
        _order.paymentToken = paymentToken_;
        _order.price = price_;
        _order.nftAddress = nftAddress_;
        _order.startTime = block.timestamp;
        _order.endTime = endTime_;
        _orderIdCount.increment();

        IERC721(nftAddress_).transferFrom(_msgSender(), address(this), tokenId_);

        emit OrderAdded(
            _orderId,
            _msgSender(),
            tokenId_,
            paymentToken_,
            price_,
            nftAddress_,
            block.timestamp,
            endTime_
        );
    }

    function cancelOrder(uint256 orderId_) public {
        Order storage _order = orders[orderId_];
        require(_order.buyer == address(0), "NFTMarketplace: buyer must be zero");
        require(_order.seller == _msgSender(), "NFTMarketplace: must be owner");
        uint256 _tokenId = _order.tokenId;
        IERC721(_order.nftAddress).transferFrom(address(this), _msgSender(), _tokenId);
        delete orders[orderId_];
        emit OrderCancelled(orderId_);
    }

    function priceUpdated(uint256 orderId_, uint256 price_) public {
        Order storage _order = orders[orderId_];
        require(_order.buyer == address(0), "NFTMarketplace: buyer must be zero");
        require(_order.seller == _msgSender(), "NFTMarketplace: must be owner");
        require(block.timestamp >= _order.startTime && block.timestamp <= _order.endTime, "out of time listing");
        require(_order.price != price_, "same old price");
        _order.price = price_;
        emit PriceUpdated(orderId_, price_);
    }

    function executeOrder(uint256 orderId_, uint256 price_) public canExecute(orderId_, _msgSender(), price_)
    {
        Order storage _order = orders[orderId_];
        require(block.timestamp >= _order.startTime && block.timestamp <= _order.endTime, "out of time listing");
        _order.buyer = _msgSender();
        uint256 _feeAmount = _calculateFee(orderId_);
        if (_feeAmount > 0) {
            IERC20(_order.paymentToken).safeTransferFrom(
                _msgSender(),
                feeRecipient,
                _feeAmount
            );
        }

        uint256 _feeCreatorAmount = _calculateFeeCreator(orderId_);
        if (_feeCreatorAmount > 0) {
            IERC20(_order.paymentToken).safeTransferFrom(
                _msgSender(),
                creatorOfNFT[_order.nftAddress],
                _feeCreatorAmount
            );
        }

        IERC20(_order.paymentToken).safeTransferFrom(
            _msgSender(),
            _order.seller,
            _order.price - _feeAmount - _feeCreatorAmount
        );

        IERC721(_order.nftAddress).transferFrom(address(this), _msgSender(), _order.tokenId);

        emit OrderMatched(
            orderId_,
            _order.seller,
            _order.buyer,
            _order.tokenId,
            _order.paymentToken,
            _order.price
        );
    }

    mapping(uint256 => mapping(address => uint256)) public offers;
    function makeOffer(uint256 orderId_, uint256 price_) public {
        Order storage _order = orders[orderId_];
        require(block.timestamp >= _order.startTime && block.timestamp <= _order.endTime, "out of time listing");
        require(msg.sender != _order.seller, "you don't allow!");
        IERC20 paymentToken = IERC20(_order.paymentToken);
        uint256 allowance = paymentToken.allowance(msg.sender, address(this));
        require(allowance >= price_, "user not approve for marketplace");
        offers[orderId_][msg.sender] = price_;
        emit MakeOffer( orderId_, msg.sender, price_);
    }

    function executeOffer(uint256 orderId_, uint256 price_, address buyer_) external {
        Order storage _order = orders[orderId_];
        require(block.timestamp >= _order.startTime && block.timestamp <= _order.endTime, "out of time listing");
        require(msg.sender == _order.seller, "you don't allow!");
        require(IERC20(_order.paymentToken).balanceOf(buyer_) >= price_, "cant't make offer");
        require(IERC20(_order.paymentToken).allowance(buyer_, address(this)) >= price_, "Insufficient allowance");
        require(offers[orderId_][buyer_] == price_, "buyer not make offer yet");
        uint256 _feeAmount = _calculateFee(orderId_);
        if (_feeAmount > 0) {
            IERC20(_order.paymentToken).safeTransferFrom(
                buyer_,
                feeRecipient,
                _feeAmount
            );
        }

        uint256 _feeCreatorAmount = _calculateFeeCreator(orderId_);
        if (_feeCreatorAmount > 0) {
            IERC20(_order.paymentToken).safeTransferFrom(
                buyer_,
                creatorOfNFT[_order.nftAddress],
                _feeCreatorAmount
            );
        }

        IERC20(_order.paymentToken).safeTransferFrom(
            buyer_,
            _order.seller,
            price_ - _feeAmount - _feeCreatorAmount
        );
        IERC721(_order.nftAddress).transferFrom(address(this), _msgSender(), _order.tokenId);
        _order.price = price_;
        _order.buyer = buyer_;
        emit OrderMatched(
            orderId_,
            _order.seller,
            _order.buyer,
            _order.tokenId,
            _order.paymentToken,
            _order.price
        );
    }

    struct OrderAuction {
        address nftAddress;
        uint256 tokenId;
        address paymentToken;
        uint256 startBlock;
        uint256 endBlock;
        uint256 highestBid;
        address highestBidder;
        address seller;
        mapping(address => uint256) bids;
    }

    mapping(uint256 => OrderAuction) public orderAuction;

    Counters.Counter private _auctionIdCount;

    function addAuction(address nftAddress_, uint256 tokenId_, address paymentToken_, uint256 minPrice_, uint256 startBlock_, uint256 endBlock_) public onlySupportedPaymentToken(paymentToken_) {
        require(nftForSales[nftAddress_], "NFTAddress nonexits!");
        require(
            IERC721(nftAddress_).ownerOf(tokenId_) == _msgSender(),
            "sender is not owner of token"
        );
        require(
            IERC721(nftAddress_).getApproved(tokenId_) == address(this) ||
                IERC721(nftAddress_).isApprovedForAll(_msgSender(), address(this)),
            "NFTMarketplace: The contract is unauthorized to manage this token"
        );
        require(minPrice_ >= 0, "NFTMarketplace: price must be greater than 0");

        uint256 _auctionId = _auctionIdCount.current();
        OrderAuction storage _orderAuction = orderAuction[_auctionId];
        _orderAuction.startBlock = startBlock_;
        _orderAuction.endBlock = endBlock_;
        _orderAuction.nftAddress = nftAddress_;
        _orderAuction.tokenId = tokenId_;
        _orderAuction.paymentToken = paymentToken_;
        _orderAuction.seller = msg.sender;
        _auctionIdCount.increment();

        IERC721(nftAddress_).transferFrom(_msgSender(), address(this), tokenId_);
        emit AddOrderAuction( _auctionId, nftAddress_,  tokenId_, paymentToken_, startBlock_,  endBlock_, msg.sender, minPrice_);
    }

    function cancelAuction(uint256 auctionId_) public {
        OrderAuction storage _orderAuction = orderAuction[auctionId_];
        require(block.timestamp < _orderAuction.startBlock, "Auction started");
        require(msg.sender == _orderAuction.seller, "Only the owner can end the auction");
        IERC721(_orderAuction.nftAddress).transferFrom(address(this), msg.sender, _orderAuction.tokenId);
        delete orderAuction[auctionId_];
        emit CancelAuction(auctionId_);
    }

    function bid(uint256 auctionId_, uint256 bidPrice_) public {
        OrderAuction storage _orderAuction = orderAuction[auctionId_];
        require(msg.sender != _orderAuction.seller, "Owner can't bid on own NFT");
        require(block.timestamp >= _orderAuction.startBlock && block.timestamp <= _orderAuction.endBlock, "Auction is not currently active");
        require((_orderAuction.bids[msg.sender] + bidPrice_) > _orderAuction.highestBid, "Bid must be greater than current highest bid");
        _orderAuction.bids[msg.sender] += bidPrice_;
        IERC20(_orderAuction.paymentToken).transferFrom(msg.sender, address(this), bidPrice_);
        _orderAuction.highestBidder = msg.sender;
        _orderAuction.highestBid =  _orderAuction.bids[_orderAuction.highestBidder];
        emit BidPlaced(auctionId_, msg.sender, bidPrice_);
    }
    
    function withdraw(uint256 auctionId_) public {
        OrderAuction storage _orderAuction = orderAuction[auctionId_];
        require(block.timestamp > _orderAuction.endBlock, "Auction has not yet ended");
        uint256 amount = _orderAuction.bids[msg.sender];
        require(amount > 0, "No funds to withdraw");
        _orderAuction.bids[msg.sender] = 0;
        IERC20(_orderAuction.paymentToken).transfer(msg.sender, amount);
        emit WithdrawAuction(auctionId_, _orderAuction.paymentToken, amount);
    }

    function endAuction(uint256 auctionId_) public {
        OrderAuction storage _orderAuction = orderAuction[auctionId_];
        require(block.timestamp > _orderAuction.endBlock, "Auction has not yet ended");
        require(msg.sender == _orderAuction.seller, "Only the owner can end the auction");
        // Transfer NFT to highest bidder
        IERC721(_orderAuction.nftAddress).transferFrom(address(this), _orderAuction.highestBidder, _orderAuction.tokenId);
        uint256 amount = _orderAuction.highestBid;
        _orderAuction.highestBid = 0;
        uint256 _feeAmount = (feeRate * amount) / 10**(feeDecimal + 2);
        if (_feeAmount > 0) {
            IERC20(_orderAuction.paymentToken).safeTransferFrom(
                msg.sender,
                feeRecipient,
                _feeAmount
            );
        }
        IERC20(_orderAuction.paymentToken).transfer(msg.sender, amount - _feeAmount);
        emit AuctionEnded(_orderAuction.highestBidder, amount - _feeAmount);
    }
}
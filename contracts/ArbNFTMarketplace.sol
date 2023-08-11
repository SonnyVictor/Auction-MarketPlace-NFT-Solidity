// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract ArbNFTMarketplace is IERC721Receiver, Ownable, ReentrancyGuard {
    using SafeMath for uint256;
    IERC721Enumerable private nft;

    constructor(IERC721Enumerable _nft) {
        nft = _nft;
    }

    bool private paused;

    struct ListDetail {
        address payable seller;
        uint256 tokenId;
        uint256 price;
        uint256 timeStart;
        uint256 timeEnd;
        bool isSold;
        bool currentlyListed;
    }
    mapping(uint256 => ListDetail) private listDetail;

    ListDetail[] private arrListDetail;

    event ListNFT(
        address indexed _from,
        uint256 _tokenId,
        uint256 _price,
        uint256 timeStart,
        uint256 timeEnd
    );
    event UnlistNFT(address indexed _from, uint256 _tokenId);
    event BuyNFT(address indexed _from, uint256 _tokenId, uint256 _price);
    event UpdateListingNFTPrice(uint256 _tokenId, uint256 _price);
    event userClaimNFTEndTime(
        address userClaim,
        uint256 _tokenId,
        uint256 _timeClaim
    );
    event SetTax(uint256 _taxService, uint256 _taxCreator);
    event SetNFT(IERC721 _nft);

    uint256 private taxService = 2;
    uint256 private taxCreator = 7;

    uint256 private _nftsSold = 0;

    address private ownerARBNFT;

    function setTax(
        uint256 _taxService,
        uint256 _taxCreator
    ) external onlyOwner {
        taxService = _taxService;
        taxCreator = _taxCreator;
        emit SetTax(_taxService, _taxCreator);
    }

    function setNft(IERC721Enumerable _nft) external onlyOwner {
        nft = _nft;
        emit SetNFT(_nft);
    }

    function setAddressOwnerARBNFT(address _add) external onlyOwner {
        ownerARBNFT = _add;
    }

    // pause lai
    // chuyen nft lai cho chu so huu khi khong dung contract nay nua

    function listNft(uint256 _tokenId, uint256 _price, uint256 _time) external {
        require(paused == false, "Contract is paused");
        require(
            nft.ownerOf(_tokenId) == msg.sender,
            "You are not the owner of this NFT"
        );
        require(
            nft.getApproved(_tokenId) == address(this),
            "Marketplace is not approved to transfer this NFT"
        );
        listDetail[_tokenId] = ListDetail(
            payable(msg.sender),
            _tokenId,
            _price,
            block.timestamp,
            block.timestamp + _time,
            false,
            true
        );
        nft.safeTransferFrom(msg.sender, address(this), _tokenId);

        arrListDetail.push(
            ListDetail({
                seller: payable(msg.sender),
                tokenId: _tokenId,
                price: _price,
                timeStart: block.timestamp,
                timeEnd: block.timestamp + _time,
                isSold: false,
                currentlyListed: true
            })
        );
        emit ListNFT(
            msg.sender,
            _tokenId,
            _price,
            block.timestamp,
            block.timestamp + _time
        );
    }

    function unlistNft(uint256 _tokenId) external {
        require(
            nft.ownerOf(_tokenId) == address(this),
            "This NFT doesn't exist on marketplace"
        );
        require(
            listDetail[_tokenId].seller == msg.sender || msg.sender == owner(),
            "Only owner can unlist this NFT"
        );
        require(listDetail[_tokenId].isSold == false, "You already sold NFT");
        require(
            listDetail[_tokenId].currentlyListed == true,
            "You already sold NFT"
        );
        require(
            listDetail[_tokenId].timeEnd >= block.timestamp &&
                listDetail[_tokenId].timeStart <= block.timestamp,
            "Over time"
        );
        nft.safeTransferFrom(
            address(this),
            listDetail[_tokenId].seller,
            _tokenId
        );
        listDetail[_tokenId].currentlyListed = false;
        delete listDetail[_tokenId];
        removeToken(_tokenId);
        emit UnlistNFT(msg.sender, _tokenId);
    }

    function updateListingNftPrice(uint256 _tokenId, uint256 _price) external {
        require(
            nft.ownerOf(_tokenId) == address(this),
            "This NFT doesn't exist on marketplace"
        );
        require(
            listDetail[_tokenId].seller == msg.sender,
            "Only owner can update price of this NFT"
        );
        require(
            listDetail[_tokenId].timeEnd >= block.timestamp &&
                listDetail[_tokenId].timeStart <= block.timestamp,
            "Over time"
        );

        listDetail[_tokenId].price = _price;
        emit UpdateListingNFTPrice(_tokenId, _price);
    }

    function buyNft(uint256 _tokenId) public payable nonReentrant {
        require(
            nft.ownerOf(_tokenId) == address(this),
            "This NFT doesn't exist on marketplace"
        );
        require(
            listDetail[_tokenId].price == msg.value,
            "Minimum price has not been reached"
        );
        require(listDetail[_tokenId].isSold == false, "NFT alredy sold");
        require(listDetail[_tokenId].currentlyListed == true, "NFT not list");

        _nftsSold = _nftsSold + 1;

        // Callculate Tax fee
        uint256 totalTaxService = caluteFee(
            listDetail[_tokenId].price,
            taxService
        );

        uint256 totalTaxCreator = caluteFee(
            listDetail[_tokenId].price,
            taxCreator
        );
        bool sentForCreator = payable(ownerARBNFT).send(totalTaxCreator);
        require(sentForCreator, "Failed to send Ether creator");

        uint256 totalUserReceive = listDetail[_tokenId].price -
            totalTaxService -
            totalTaxCreator;
        bool sentForUser = listDetail[_tokenId].seller.send(totalUserReceive);
        require(sentForUser, "Failed to send Ether User");

        // transfer NFT
        nft.safeTransferFrom(address(this), msg.sender, _tokenId);
        listDetail[_tokenId].isSold = true;
        listDetail[_tokenId].currentlyListed = false;

        removeToken(_tokenId);
        emit BuyNFT(msg.sender, _tokenId, msg.value);
    }

    function caluteFee(
        uint256 _amount,
        uint256 rate
    ) private pure returns (uint256) {
        return _amount.mul(rate).div(100);
    }

    function claimNFTEndTime(uint256 _tokenId) external {
        require(
            nft.ownerOf(_tokenId) == address(this),
            "This NFT doesn't exist on marketplace"
        );
        require(
            listDetail[_tokenId].seller == msg.sender,
            "Only owner can update price of this NFT"
        );
        require(
            listDetail[_tokenId].timeEnd <= block.timestamp,
            "Time is not over"
        );
        require(listDetail[_tokenId].isSold == false, "NFT is sold");
        require(
            listDetail[_tokenId].currentlyListed == true,
            "NFT alredy listed"
        );
        nft.safeTransferFrom(address(this), msg.sender, _tokenId);
        delete listDetail[_tokenId];
        emit userClaimNFTEndTime(msg.sender, _tokenId, block.timestamp);
    }

    function withdraw() external payable onlyOwner {
        uint256 _amount = address(this).balance;
        bool sent = payable(msg.sender).send(_amount);
        require(sent, "Failed to send Ether");
    }

    function countCurrentNFTListed() public view returns (uint256) {
        return nft.balanceOf(address(this));
    }

    function getCountNFTSold() public view returns (uint256) {
        return _nftsSold;
    }

    function removeToken(uint256 tokenIdToRemove) private {
        for (uint256 i = 0; i < arrListDetail.length; i++) {
            if (arrListDetail[i].tokenId == tokenIdToRemove) {
                if (i < arrListDetail.length - 1) {
                    arrListDetail[i] = arrListDetail[arrListDetail.length - 1];
                }
                arrListDetail.pop();
                delete listDetail[tokenIdToRemove];

                break;
            }
        }
    }

    function getTokenIdsFromListDetailArray()
        public
        view
        returns (uint256[] memory)
    {
        uint256[] memory tokenIds = new uint256[](arrListDetail.length);

        for (uint256 i = 0; i < arrListDetail.length; i++) {
            tokenIds[i] = arrListDetail[i].tokenId;
        }

        return tokenIds;
    }

    function getAllValuesFromStructs()
        public
        view
        returns (ListDetail[] memory)
    {
        ListDetail[] memory allValues = new ListDetail[](arrListDetail.length);

        for (uint256 i = 0; i < arrListDetail.length; i++) {
            allValues[i] = arrListDetail[i];
        }
        return allValues;
    }

    function getTokenIdDetail(
        uint256 _tokenId
    ) public view returns (ListDetail memory) {
        return listDetail[_tokenId];
    }

    function setPaused(bool _paused) external onlyOwner {
        paused = _paused;
    }

    function getPaused() external view returns (bool) {
        return paused;
    }

    // modifier onlyAuctioneer(uint256 _auctionId) {
    //     require((msg.sender == auction[_auctionId].auctioneer||msg.sender==owner()), "Only auctioneer or owner can perform this action");
    //     _;
    // }

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

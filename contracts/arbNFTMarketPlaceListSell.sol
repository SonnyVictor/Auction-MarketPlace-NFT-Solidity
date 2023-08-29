// // SPDX-License-Identifier: MIT
// pragma solidity ^0.8.15;
// import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
// import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
// import "@openzeppelin/contracts/utils/Counters.sol";
// import "@openzeppelin/contracts/access/Ownable.sol";
// import "@openzeppelin/contracts/utils/math/SafeMath.sol";
// import "@openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol";
// import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

// contract arbNFTMarketPlaceListSell is
//     IERC721Receiver,
//     Ownable,
//     ReentrancyGuard
// {
//     using SafeMath for uint256;
//     using Counters for Counters.Counter;
//     IERC721Enumerable private nftContract;

//     constructor(IERC721Enumerable _nft) {
//         nftContract = _nft;
//         ownerARBNFT = owner();
//     }

//     Counters.Counter private _items;
//     Counters.Counter private _soldItems;

//     uint256 private taxService = 2;
//     uint256 private taxCreator = 7;

//     address private ownerARBNFT;

//     bool private paused;
//     struct MarketplaceItem {
//         uint256 itemId;
//         uint256 tokenId;
//         address payable seller;
//         address payable owner;
//         uint256 price;
//         uint256 timeStart;
//         uint256 timeEnd;
//         bool sold;
//         bool currentList;
//     }
//     mapping(uint256 => MarketplaceItem) private idToMarketplaceItem;

//     event MarketplaceItemCreated(
//         uint256 indexed itemId,
//         uint256 indexed tokenId,
//         address seller,
//         address owner,
//         uint256 price,
//         uint256 timeStart,
//         uint256 timeEnd,
//         bool sold
//     );

//     event SetNFT(IERC721 _nft);
//     event SetTax(uint256 _taxService, uint256 _taxCreator);
//     event UpdatePriceNftOnSale(uint256 tokenId, uint256 _price);
//     event UnListNFTOnSale(address seller, uint256 tokenId, uint256 timeUnList);
//     event BuyNFT(address indexed _from, uint256 _tokenId, uint256 _price);

//     // places an item for sale on the marketplace
//     function createMarketplaceItem(
//         uint256 _tokenId,
//         uint256 _price,
//         uint256 _time
//     ) external nonReentrant {
//         require(paused == false, "Contract is paused");
//         require(
//             nftContract.ownerOf(_tokenId) == msg.sender,
//             "This NFT doesn't exist on marketplace"
//         );
//         require(
//             nftContract.getApproved(_tokenId) == address(this),
//             "Marketplace is not approved to transfer this NFT"
//         );
//         require(_price > 0, "Price must be at least 1 wei");
//         _items.increment();
//         uint256 itemId = _items.current();

//         idToMarketplaceItem[itemId] = MarketplaceItem(
//             itemId,
//             _tokenId,
//             payable(msg.sender),
//             payable(address(0)),
//             _price,
//             block.timestamp,
//             block.timestamp + _time,
//             false,
//             true
//         );

//         nftContract.transferFrom(msg.sender, address(this), _tokenId);

//         emit MarketplaceItemCreated(
//             itemId,
//             _tokenId,
//             msg.sender,
//             address(0),
//             _price,
//             block.timestamp,
//             block.timestamp + _time,
//             false
//         );
//     }

//     function buyNft(uint256 itemId) external payable nonReentrant {
//         uint256 tokenId = idToMarketplaceItem[itemId].tokenId;
//         require(
//             nftContract.ownerOf(tokenId) == address(this),
//             "This NFT doesn't exist on marketplace"
//         );
//         address payable addressSeller = idToMarketplaceItem[itemId].seller;
//         uint256 price = idToMarketplaceItem[itemId].price;
//         require(
//             msg.value == price,
//             "Please submit the asking price in order to complete the purchase"
//         );
//         // Transfer NFT
//         nftContract.safeTransferFrom(address(this), msg.sender, tokenId);
//         idToMarketplaceItem[itemId].sold = true;
//         idToMarketplaceItem[itemId].currentList = false;
//         idToMarketplaceItem[itemId].owner = payable(msg.sender);
//         _soldItems.increment();
//         // Transfer Money for creator and ownerARBNFT
//         uint256 totalTaxService = caluteFee(price, taxService);
//         uint256 totalTaxCreator = caluteFee(price, taxCreator);
//         bool sentForCreator = payable(ownerARBNFT).send(totalTaxCreator);
//         require(sentForCreator, "Failed to send Ether creator");

//         uint256 totalUserReceive = price - totalTaxService - totalTaxCreator;
//         bool sentForUser = addressSeller.send(totalUserReceive);
//         require(sentForUser, "Failed to send Ether User");

//         emit BuyNFT(msg.sender, tokenId, msg.value);
//     }

//     function updatePriceNftOnSale(uint256 itemId, uint256 _price) external {
//         uint256 tokenId = idToMarketplaceItem[itemId].tokenId;
//         require(
//             nftContract.ownerOf(tokenId) == address(this),
//             "This NFT doesn't exist on marketplace"
//         );
//         address addressSeller = idToMarketplaceItem[itemId].seller;
//         require(msg.sender == addressSeller, "Only owner can unlist this NFT");

//         idToMarketplaceItem[itemId].price = _price;
//         emit UpdatePriceNftOnSale(tokenId, _price);
//     }

//     function unListNftOnSale(uint256 _itemId) external {
//         uint256 tokenId = idToMarketplaceItem[_itemId].tokenId;
//         require(
//             nftContract.ownerOf(tokenId) == address(this),
//             "This NFT doesn't exist on marketplace"
//         );
//         address addressSeller = idToMarketplaceItem[_itemId].seller;
//         require(
//             msg.sender == addressSeller || msg.sender == owner(),
//             "Only owner can unlist this NFT"
//         );

//         idToMarketplaceItem[_itemId].currentList = false;
//         idToMarketplaceItem[_itemId].sold = false;
//         nftContract.safeTransferFrom(address(this), addressSeller, tokenId);

//         emit UnListNFTOnSale(msg.sender, tokenId, block.timestamp);
//     }

//     function fetchMarketplaceItems()
//         public
//         view
//         returns (MarketplaceItem[] memory)
//     {
//         uint256 itemCount = _items.current();
//         uint256 unsoldItemCount = _items.current() - _soldItems.current();

//         MarketplaceItem[] memory validItems = new MarketplaceItem[](
//             unsoldItemCount
//         );
//         uint256 validItemCount = 0;

//         for (uint256 i = 0; i < itemCount; i++) {
//             MarketplaceItem storage currentItem = idToMarketplaceItem[i + 1];

//             if (
//                 currentItem.owner == address(0) &&
//                 currentItem.currentList == true &&
//                 currentItem.timeEnd > block.timestamp &&
//                 currentItem.timeEnd > 0
//             ) {
//                 if (
//                     currentItem.seller != address(0) &&
//                     currentItem.tokenId != 0 &&
//                     currentItem.price != 0
//                 ) {
//                     validItems[validItemCount] = currentItem;
//                     validItemCount++;
//                 }
//             }
//         }
//         MarketplaceItem[] memory items = new MarketplaceItem[](validItemCount);
//         for (uint256 i = 0; i < validItemCount; i++) {
//             items[i] = validItems[i];
//         }

//         return items;
//     }

//     // // User on Sale
//     // function fetchItemsOnSale()
//     //     public
//     //     view
//     //     returns (MarketplaceItem[] memory)
//     // {
//     //     uint256 totalItemCount = _items.current();
//     //     uint256 itemCount = 0;
//     //     uint256 currentIndex = 0;

//     //     for (uint256 i = 0; i < totalItemCount; i++) {
//     //         if (idToMarketplaceItem[i + 1].seller == msg.sender && idToMarketplaceItem[i + 1].currentList == true ) {
//     //             itemCount += 1;
//     //         }
//     //     }

//     //     MarketplaceItem[] memory items = new MarketplaceItem[](itemCount);

//     //     for (uint256 i = 0; i < totalItemCount; i++) {
//     //         if (idToMarketplaceItem[i + 1].seller == msg.sender &&  idToMarketplaceItem[i + 1].currentList == true) {
//     //             uint256 currentId = i + 1;
//     //             MarketplaceItem storage currentItem = idToMarketplaceItem[
//     //                 currentId
//     //             ];
//     //             items[currentIndex] = currentItem;
//     //             currentIndex += 1;
//     //         }
//     //     }

//     //     return items;
//     // }

//     // testtttttttttttttttttt
//     function fetchItemsOnSale(
//         address _addr
//     ) public view returns (MarketplaceItem[] memory) {
//         uint256 totalItemCount = _items.current();
//         uint256 itemCount = 0;
//         uint256 currentIndex = 0;

//         for (uint256 i = 0; i < totalItemCount; i++) {
//             if (
//                 idToMarketplaceItem[i + 1].seller == _addr &&
//                 idToMarketplaceItem[i + 1].currentList == true
//             ) {
//                 itemCount += 1;
//             }
//         }

//         MarketplaceItem[] memory items = new MarketplaceItem[](itemCount);

//         for (uint256 i = 0; i < totalItemCount; i++) {
//             if (
//                 idToMarketplaceItem[i + 1].seller == _addr &&
//                 idToMarketplaceItem[i + 1].currentList == true
//             ) {
//                 uint256 currentId = i + 1;
//                 MarketplaceItem storage currentItem = idToMarketplaceItem[
//                     currentId
//                 ];
//                 items[currentIndex] = currentItem;
//                 currentIndex += 1;
//             }
//         }

//         return items;
//     }

//     // function fetchMyNFTsBought() public view returns (MarketplaceItem[] memory) {
//     //     uint256 totalItemCount = _items.current();
//     //     uint256 itemCount = 0;
//     //     uint256 currentIndex = 0;

//     //     for (uint256 i = 0; i < totalItemCount; i++) {
//     //         if (idToMarketplaceItem[i + 1].owner == msg.sender) {
//     //             itemCount += 1;
//     //         }
//     //     }

//     //     MarketplaceItem[] memory items = new MarketplaceItem[](itemCount);
//     //     for (uint256 i = 0; i < totalItemCount; i++) {
//     //         if (idToMarketplaceItem[i + 1].owner == msg.sender) {
//     //             uint256 currentId = i + 1;
//     //             MarketplaceItem storage currentItem = idToMarketplaceItem[
//     //                 currentId
//     //             ];
//     //             items[currentIndex] = currentItem;
//     //             currentIndex += 1;
//     //         }
//     //     }
//     //     return items;
//     // }

//     function fetchMyNFTsBought(
//         address _add
//     ) public view returns (MarketplaceItem[] memory) {
//         uint256 totalItemCount = _items.current();
//         uint256 itemCount = 0;
//         uint256 currentIndex = 0;

//         for (uint256 i = 0; i < totalItemCount; i++) {
//             if (idToMarketplaceItem[i + 1].owner == _add) {
//                 itemCount += 1;
//             }
//         }

//         MarketplaceItem[] memory items = new MarketplaceItem[](itemCount);
//         for (uint256 i = 0; i < totalItemCount; i++) {
//             if (idToMarketplaceItem[i + 1].owner == _add) {
//                 uint256 currentId = i + 1;
//                 MarketplaceItem storage currentItem = idToMarketplaceItem[
//                     currentId
//                 ];
//                 items[currentIndex] = currentItem;
//                 currentIndex += 1;
//             }
//         }
//         return items;
//     }

//     function withdraw() external payable onlyOwner {
//         uint256 _amount = address(this).balance;
//         bool sent = payable(msg.sender).send(_amount);
//         require(sent, "Failed to send Ether");
//     }

//     function caluteFee(
//         uint256 _amount,
//         uint256 rate
//     ) private pure returns (uint256) {
//         return _amount.mul(rate).div(100);
//     }

//     function setTax(
//         uint256 _taxService,
//         uint256 _taxCreator
//     ) external onlyOwner {
//         taxService = _taxService;
//         taxCreator = _taxCreator;
//         emit SetTax(_taxService, _taxCreator);
//     }

//     function getTax() external view returns (uint256, uint256) {
//         return (taxService, taxCreator);
//     }

//     function setNft(IERC721Enumerable _nft) external onlyOwner {
//         nftContract = _nft;
//         emit SetNFT(_nft);
//     }

//     function getNFT() external view returns (IERC721Enumerable) {
//         return nftContract;
//     }

//     function setAddressOwnerARBNFT(address _add) external onlyOwner {
//         ownerARBNFT = _add;
//     }

//     function getAddressOwnerARBNFT() external view returns (address) {
//         return ownerARBNFT;
//     }

//     function getItemSold() external view returns (uint256) {
//         return _soldItems.current();
//     }

//     function setPaused(bool _paused) external onlyOwner {
//         paused = _paused;
//     }

//     function getPaused() external view returns (bool) {
//         return paused;
//     }

//     function countCurrentNFTListed() public view returns (uint256) {
//         return nftContract.balanceOf(address(this));
//     }

//     function onERC721Received(
//         address,
//         address,
//         uint256,
//         bytes calldata
//     ) external pure override returns (bytes4) {
//         return
//             bytes4(
//                 keccak256("onERC721Received(address,address,uint256,bytes)")
//             );
//     }
// }

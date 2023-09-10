// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract AIImageNew is ERC721, ERC721URIStorage, Ownable {
    using EnumerableSet for EnumerableSet.AddressSet;

    using Counters for Counters.Counter;
    using SafeERC20 for IERC20;
    Counters.Counter private _tokenIdCounter;
    EnumerableSet.AddressSet private _supportedPaymentTokens;
    event ApprovePaymentTokens(uint256 orderId, address buyer, uint256 price);
    uint256 price;
    address feeRecipient;
    constructor() ERC721("AI IMAGE NFT", "AIN") {
        
    }

    modifier onlySupportedPaymentToken(address paymentToken_) {
        require(
            isPaymentTokenSupported(paymentToken_),
            "NFTMarketplace: unsupport payment token"
        );
        _;
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
    }

    function updateFeeRecipient(address feeRecipient_) external onlyOwner {
        require(
            feeRecipient_ != address(0),
            "NFTMarketplace: feeRecipient_ is zero address"
        );
        feeRecipient = feeRecipient_;
    }

    function isPaymentTokenSupported(address paymentToken_)
        public
        view
        returns (bool)
    {
        return _supportedPaymentTokens.contains(paymentToken_);
    }

    function safeMint(
        address to,
        string memory uri,
        address paymentToken
    ) public onlyOwner {
        require(
            isPaymentTokenSupported(paymentToken),
            "Token is not allowance"
        );
        require(
            IERC20(paymentToken).allowance(to, address(this)) >= price,
            "Insufficient allowance"
        );
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);
        IERC20(paymentToken).safeTransferFrom(to, feeRecipient, price);
    }

    function addPriceMintNFT(uint256 _price) public onlyOwner {
        price = _price;
    }

    function prices() public view returns (uint256) {
        return price;
    }


    function _burn(uint256 tokenId)
        internal
        override(ERC721, ERC721URIStorage)
    {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }
}
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
/**
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

// OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() {
        _transferOwnership(_msgSender());
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(
            newOwner != address(0),
            "Ownable: new owner is the zero address"
        );
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

contract Distribution is Ownable {
    uint256 private totalAmount;
    uint256 private lengthUser;
    struct AddressUserReceiver {
        address payable userAddressReceiver;
        uint256 percentage;
        bool isReceive;
    }

    mapping(address => uint256) private balanceOf;
    mapping(uint256 => AddressUserReceiver) private addressReceiver;

    event BalanceOf(address addressDesposit, uint256 amount, uint256 time);
    event AddressRemoved(address addressRemove);

    function desposit() external payable {
        require(msg.value > 0, "Insufficient account balance");
        require(lengthUser > 0, "Pls Add Number User");
        balanceOf[msg.sender] += msg.value;
        totalAmount += msg.value;
        emit BalanceOf(msg.sender, msg.value, block.timestamp);

        for (uint256 i = 0; i < lengthUser; i++) {
            AddressUserReceiver storage receiver = addressReceiver[i];
            uint256 amountToTransfer = (totalAmount * (receiver.percentage)) /
                100;
            receiver.isReceive = true;
            (bool sent, ) = payable(receiver.userAddressReceiver).call{
                value: amountToTransfer
            }("");
            require(sent, "Failed to send Kayln");
        }
    }

    function setLengthUser(uint256 _lengUser) external onlyOwner {
        lengthUser = _lengUser;
    }

    function setAddress(
        uint256 _index,
        address _address,
        uint256 _percentage
    ) external onlyOwner {
        require(_address != address(0), "Invalid address");
        addressReceiver[_index] = AddressUserReceiver(
            payable(_address),
            _percentage,
            false
        );
    }

    function withDrawAll() external payable onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0, "Contract balance is zero");
        (bool sent, ) = payable(msg.sender).call{value: balance}("");
        require(sent, "Failed to send Ether");
    }

    function getAddressReceive(
        uint256 _index
    ) external view returns (address, uint256, bool) {
        AddressUserReceiver storage getAddress = addressReceiver[_index];
        return (
            getAddress.userAddressReceiver,
            getAddress.percentage,
            getAddress.isReceive
        );
    }

    function getToTalAmount() external view returns (uint256) {
        return totalAmount;
    }

    function getLengthUser() external view returns (uint256) {
        return lengthUser;
    }

    function getBalanceOf(address _address) external view returns (uint256) {
        if (balanceOf[_address] == 0) return 0;
        return balanceOf[_address];
    }
}

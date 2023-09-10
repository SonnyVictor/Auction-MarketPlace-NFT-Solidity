// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "./DateTime.sol";

contract LockTokenBSCS is Ownable {
    IERC20 private token;
    DateTime private dateTimeContract;
    uint256 public constant totalAmount = 200_000_000 * 10 ** 18;

    uint256 public constant UnLockEachMonth = 10000 * 10 ** 18;
    struct privateSaler {
        uint256 withdrawTimeUser;
        uint256 amount;
        bool isWithdraw;
    }

    mapping(uint256 => privateSaler) private withdrawTime;

    event WithdrawToken(address addressWithdraw, uint256 amount, uint256 time);
    event WithdrawTokenEachMonth(
        uint256 id,
        address addressWithdraw,
        uint256 amount,
        uint256 time
    );

    constructor(IERC20 _token, address _addressDateTime) {
        token = IERC20(_token);
        dateTimeContract = DateTime(_addressDateTime);
    }

    function initWithdrawTime(
        uint16 _years,
        uint8 _month,
        uint8 _day,
        uint8 _numberMonths
    ) external onlyOwner {
        uint16[] memory yearsss = new uint16[](_numberMonths);
        uint8[] memory months = new uint8[](_numberMonths);

        yearsss[0] = _years;
        months[0] = _month;

        for (uint8 i = 1; i < _numberMonths; i++) {
            yearsss[i] = yearsss[i - 1];
            months[i] = months[i - 1] + 1;
            if (months[i] > 12) {
                yearsss[i]++;
                months[i] = 1;
            }
        }

        for (uint8 i = 0; i < _numberMonths; i++) {
            withdrawTime[i] = privateSaler(
                useDateTime(yearsss[i], months[i], _day),
                UnLockEachMonth,
                false
            );
        }
    }

    function getContractHoldToken() public view returns (uint256) {
        return token.balanceOf(address(this));
    }

    function getAddressOwner() public view returns (address) {
        return owner();
    }

    function withdrawTokenEachMonth(uint256 _index) external onlyOwner {
        require(
            token.balanceOf(address(this)) >= 0,
            "Insufficient account balance"
        );
        privateSaler storage infor = withdrawTime[_index];
        require(infor.isWithdraw == false, "You are withdraw");
        infor.isWithdraw = true;
        require(infor.withdrawTimeUser <= block.timestamp, "You are withdraw");
        SafeERC20.safeTransfer(token, msg.sender, infor.amount);
        emit WithdrawTokenEachMonth(
            _index,
            msg.sender,
            infor.amount,
            block.timestamp
        );
    }

    function useDateTime(
        uint16 year,
        uint8 month,
        uint8 day
    ) public view returns (uint256) {
        uint256 timestamp = dateTimeContract.toTimestamp(year, month, day);
        return timestamp;
    }

    function getWithdrawTime(
        uint256 index
    ) public view returns (uint256, uint256, bool) {
        privateSaler storage sale = withdrawTime[index];
        return (sale.withdrawTimeUser, sale.amount, sale.isWithdraw);
    }
}

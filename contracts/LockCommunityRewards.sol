// // SPDX-License-Identifier: GPL-3.0
// pragma solidity >=0.7.0 <0.9.0;

// import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
// import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
// import "@openzeppelin/contracts/access/Ownable.sol";
// import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
// import "./DateTime.sol";

// contract LockCommunityRewards is Ownable {
//     IERC20 private token;
//     DateTime private dateTimeContract;
//     uint256 public constant totalAmount = 1_800_000_000 * 10 ** 18;

//     uint256 public constant TGEAmount = 144_000_000_000 * 10 ** 18;
//     uint256 public constant NextAmount = 138_000_000_000 * 10 ** 18;

//     mapping(address => uint256) private balanceOfToken;
//     struct privateSaler {
//         uint256 withdrawTimeUser;
//         uint256 amount;
//         bool isWithdraw;
//     }

//     mapping(uint256 => privateSaler) private withdrawTime;

//     event DepositToken(
//         address addressDeposit,
//         uint256 amount,
//         uint256 timeDeposit
//     );
//     event WithdrawToken(address addressWithdraw, uint256 amount, uint256 time);
//     event WithdrawTokenEachMonth(
//         uint256 id,
//         address addressWithdraw,
//         uint256 amount,
//         uint256 time
//     );

//     constructor(IERC20 _token, address _addressDateTime) {
//         token = IERC20(_token);
//         dateTimeContract = DateTime(_addressDateTime);
//         initWithdrawTime();
//     }

//     function initWithdrawTime() internal {
//         uint16[] memory yearsss = new uint16[](13);
//         uint8[] memory months = new uint8[](13);

//         yearsss[0] = 2023;
//         months[0] = 10;

//         for (uint8 i = 1; i < 13; i++) {
//             yearsss[i] = yearsss[i - 1];
//             months[i] = months[i - 1] + 1;
//             if (months[i] > 12) {
//                 yearsss[i]++;
//                 months[i] = 1;
//             }
//         }

//         for (uint8 i = 0; i < 13; i++) {
//             if (i == 0) {
//                 withdrawTime[i] = privateSaler(
//                     useDateTime(yearsss[i], months[i], 10),
//                     TGEAmount,
//                     false
//                 );
//             } else {
//                 withdrawTime[i] = privateSaler(
//                     useDateTime(yearsss[i], months[i], 10),
//                     NextAmount,
//                     false
//                 );
//             }
//         }
//     }

//     function getContractHoldToken() public view returns (uint256) {
//         return token.balanceOf(address(this));
//     }

//     function getAddressOwner() public view returns (address) {
//         return owner();
//     }

//     function desposit(uint256 _amountToken) external {
//         require(
//             token.balanceOf(msg.sender) >= 0,
//             "Insufficient account balance"
//         );
//         balanceOfToken[msg.sender] += _amountToken;
//         SafeERC20.safeTransferFrom(
//             token,
//             msg.sender,
//             address(this),
//             _amountToken
//         );

//         emit DepositToken(msg.sender, _amountToken, block.timestamp);
//     }

//     function withdrawTokenEachMonth(uint256 _index) external onlyOwner {
//         require(
//             token.balanceOf(address(this)) >= 0,
//             "Insufficient account balance"
//         );
//         privateSaler storage infor = withdrawTime[_index];
//         require(infor.isWithdraw == false, "You are withdraw");
//         infor.isWithdraw = true;
//         require(infor.withdrawTimeUser <= block.timestamp, "You are withdraw");
//         SafeERC20.safeTransfer(token, msg.sender, infor.amount);
//         emit WithdrawTokenEachMonth(
//             _index,
//             msg.sender,
//             infor.amount,
//             block.timestamp
//         );
//     }

//     function withDrawAllToken() external onlyOwner {
//         uint256 balance = token.balanceOf(address(this));
//         SafeERC20.safeTransfer(token, msg.sender, balance);
//     }

//     function getTokenBalanceOf(
//         address _address
//     ) external view returns (uint256) {
//         return balanceOfToken[_address];
//     }

//     function useDateTime(
//         uint16 year,
//         uint8 month,
//         uint8 day
//     ) public view returns (uint256) {
//         uint256 timestamp = dateTimeContract.toTimestamp(year, month, day);
//         return timestamp;
//     }

//     function getWithdrawTime(
//         uint256 index
//     ) public view returns (uint256, uint256, bool) {
//         privateSaler storage sale = withdrawTime[index];
//         return (sale.withdrawTimeUser, sale.amount, sale.isWithdraw);
//     }
// }

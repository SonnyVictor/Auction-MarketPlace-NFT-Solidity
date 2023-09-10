// // SPDX-License-Identifier: GPL-3.0
// pragma solidity >=0.7.0 <0.9.0;

// import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
// import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
// import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
// import "@openzeppelin/contracts/access/Ownable.sol";

// contract LockCommunityRewardsTwentyMinus is Ownable {
//     IERC20 private token;
//     uint256 public constant totalAmount = 1_800_000_000 * 10 ** 18;

//     uint256 public constant TGEAmount = 144_000_000 * 10 ** 18;
//     uint256 public constant NextAmount = 138_000_000 * 10 ** 18;

//     struct privateSaler {
//         uint256 withdrawTimeUser;
//         uint256 amount;
//         bool isWithdraw;
//     }

//     privateSaler[] public withdrawTime;

//     function initWithdrawTime() internal {
//         uint256 currentTime = block.timestamp;
//         for (uint8 i = 1 ;i<=13;i++){
//             if (i==1){
//                 withdrawTime.push(privateSaler({
//                     withdrawTimeUser: currentTime+5 minutes,
//                     amount: TGEAmount,
//                     isWithdraw: false
//                 })
//             );
//             }else{
//                 withdrawTime.push(privateSaler({
//                     withdrawTimeUser: currentTime+(5 minutes * uint256(i)),
//                     amount: NextAmount,
//                     isWithdraw: false
//                 })
//             );      
//             }

//         }
//     }

//     constructor(IERC20 _token) {
//         token = IERC20(_token);
//         initWithdrawTime();
//     }

//     function getContractHoldToken() public view returns (uint256) {
//         return token.balanceOf(address(this));
//     }

//     function getAddressOwner() public view returns (address) {
//         return owner();
//     }

//     function desposit(uint256 _amountToken) public {
//         require(
//             token.balanceOf(msg.sender) >= 0,
//             "Insufficient account balance"
//         );
//         SafeERC20.safeTransferFrom(
//             token,
//             msg.sender,
//             address(this),
//             _amountToken
//         );
//     }

//     function withdrawTokenEachMonth(uint256 _index) external onlyOwner {
//         require(owner() == msg.sender, "You are not privateSale");
//         require(
//             token.balanceOf(address(this)) >= 0,
//             "Insufficient account balance"
//         );
//         privateSaler storage infor = withdrawTime[_index];
//         require(infor.isWithdraw == false, "You are withdraw");
//         require(infor.withdrawTimeUser < block.timestamp, "You are withdraw");
//         infor.isWithdraw = true;
//         token.transfer(owner(), infor.amount);
//     }

//     function withDrawAllToen() external onlyOwner {
//         uint256 balance = token.balanceOf(address(this));
//         token.transfer(owner(), balance);
//     }    
// }


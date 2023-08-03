//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import {Test} from "forge-std/Test.sol";
import {OurToken} from "../src/OurToken.sol";
import {DeployOurToken} from "../script/DeployOurToken.s.sol";

contract OurTokenTest is Test{
    OurToken public ourToken;
    DeployOurToken public deployer;

    address x1=makeAddr("x1");
    address x2=makeAddr("x2");

    uint256 public constant STARTING_BALANCE=1000 ether;
    function setUp() public {
        deployer = new DeployOurToken();
        ourToken = deployer.run();

        vm.prank(msg.sender);
        ourToken.transfer(x1, STARTING_BALANCE);

    }
    function testx1Balance() public {
        assertEq(ourToken.balanceOf(x1), STARTING_BALANCE);
    }
    function testAllowancesWorks() public {
        uint256 initialAllowance = 1000;
        
        //x1 approves x2 to spend 1000 tokens on his behalf
        vm.prank(x1);
        ourToken.approve(x2, initialAllowance);

        vm.prank(x2);
        ourToken.transferFrom(x1, x2, initialAllowance); // this will only go through if they are approved
        assertEq(ourToken.balanceOf(x2), initialAllowance);
        assertEq(ourToken.balanceOf(x1), STARTING_BALANCE - initialAllowance);
    }
    function testApprove() public {
    uint256 initialAllowance = 1000;
    
    // x1 approves x2 to spend 1000 tokens on their behalf
    vm.prank(x1);
    ourToken.approve(x2, initialAllowance);

    // Assert the approval
    assertEq(ourToken.allowance(x1, x2), initialAllowance);
}
function testTransfer() public {
    uint256 transferAmount = 50;

    // x1 transfers 50 tokens to x2
    vm.prank(x1);
    ourToken.transfer(x2, transferAmount);

    // Assert the balances after the transfer
    assertEq(ourToken.balanceOf(x1), STARTING_BALANCE - transferAmount);
    assertEq(ourToken.balanceOf(x2), transferAmount);
}
function testTransferFrom() public {
    uint256 initialAllowance = 1000;
    uint256 transferAmount = 500;

    // x1 approves x2 to spend 1000 tokens on their behalf
    vm.prank(x1);
    ourToken.approve(x2, initialAllowance);

    // x2 transfers 500 tokens from x1's account using allowance
    vm.prank(x2);
    ourToken.transferFrom(x1, x2, transferAmount);

    // Assert the balances after the transfer
    assertEq(ourToken.allowance(x1, x2), initialAllowance - transferAmount);
    assertEq(ourToken.balanceOf(x1), STARTING_BALANCE - transferAmount);
    assertEq(ourToken.balanceOf(x2), transferAmount);
}
function testTransferFromNotEnoughAllowance() public {
    uint256 initialAllowance = 100;
    uint256 transferAmount = 200;

    // x1 approves x2 to spend 100 tokens on their behalf
    vm.prank(x1);
    ourToken.approve(x2, initialAllowance);

    // x2 tries to transfer 200 tokens from x1's account using allowance
    vm.prank(x2);
    vm.expectRevert();
    ourToken.transferFrom(x1, x2, transferAmount);
}
function testTransferFromNotEnoughBalance() public {
    uint256 initialAllowance = 100;
    uint256 transferAmount = 200;

    // x1 approves x2 to spend 100 tokens on their behalf
    vm.prank(x1);
    ourToken.approve(x2, initialAllowance);

    // x2 tries to transfer 200 tokens from x1's account using allowance
    vm.prank(x2);
    vm.expectRevert();
    ourToken.transferFrom(x1, x2, transferAmount); // this will only go through if x1 has enough balance
}
/*function testTransferInsufficientBalance() public {
    uint256 transferAmount = 100;

    // x1 tries to transfer 200 tokens to x2, but x1 doesn't have enough balance
    vm.prank(x1);
    vm.expectRevert();
    ourToken.transfer(x2, transferAmount);
}
*/
function testDecimals() public {
    // ERC20 standard has 18 decimals by default
    uint8 expectedDecimals = 18;
    assertEq(ourToken.decimals(), expectedDecimals);
}
function testTotalSupply() public {
    // The total supply should be the same as the starting balance
    assertEq(ourToken.totalSupply(), STARTING_BALANCE);
}

}






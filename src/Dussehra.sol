// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Address} from "@openzeppelin/contracts/utils/Address.sol";
import {ChoosingRam} from "./ChoosingRam.sol";
import {RamNFT} from "./RamNFT.sol";

contract Dussehra {
    using Address for address payable;

    error Dussehra__NotEqualToEntranceFee();
    error Dussehra__AlreadyPresent();
    error Dussehra__MahuratIsNotStart();
    error Dussehra__MahuratIsFinished();
    error Dussehra__AlreadyClaimedAmount();

    address[] public WantToBeLikeRam;
    uint256 public entranceFee;
    address public organiser;
    address public SelectedRam;
    RamNFT public ramNFT;
    bool public IsRavanKilled;
    mapping (address competitor => bool isPresent) public peopleLikeRam;
    uint256 public totalAmountGivenToRam;
    ChoosingRam public choosingRamContract;


    event PeopleWhoLikeRamIsEntered(address competitor);

    modifier RamIsSelected() {
        require(choosingRamContract.isRamSelected(), "Ram is not selected yet!");
        _;
    }

    modifier OnlyRam() {
        require(choosingRamContract.selectedRam() == msg.sender, "Only Ram can call this function!");
        _;
    }

    modifier RavanKilled() {
        require(IsRavanKilled, "Ravan is not killed yet!");
        _;
    }

    constructor(uint256 _entranceFee, address _choosingRamContract, address _ramNFT) {
        entranceFee = _entranceFee;
        organiser = msg.sender;
        ramNFT = RamNFT(_ramNFT);
        choosingRamContract = ChoosingRam(_choosingRamContract);
    }

    function enterPeopleWhoLikeRam() public payable {
        if (msg.value != entranceFee) {
            revert Dussehra__NotEqualToEntranceFee();
        }

        if (peopleLikeRam[msg.sender] == true){
            revert Dussehra__AlreadyPresent();
        }
        
        peopleLikeRam[msg.sender] = true;
        WantToBeLikeRam.push(msg.sender);
        ramNFT.mintRamNFT(msg.sender);
        emit PeopleWhoLikeRamIsEntered(msg.sender);
    }

    function killRavana() public RamIsSelected {
        if (block.timestamp < 1728691069) {
            revert Dussehra__MahuratIsNotStart();
        }
        if (block.timestamp > 1728777669) {
            revert Dussehra__MahuratIsFinished();
        }
        IsRavanKilled = true;
        uint256 totalAmountByThePeople = WantToBeLikeRam.length * entranceFee;
        totalAmountGivenToRam = (totalAmountByThePeople * 50) / 100;
        (bool success, ) = organiser.call{value: totalAmountGivenToRam}("");
        require(success, "Failed to send money to organiser");
    }

    function withdraw() public RamIsSelected OnlyRam RavanKilled {
        if (totalAmountGivenToRam == 0) {
            revert Dussehra__AlreadyClaimedAmount();
        }
        uint256 amount = totalAmountGivenToRam;
        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "Failed to send money to Ram");
        totalAmountGivenToRam = 0;
    }
}

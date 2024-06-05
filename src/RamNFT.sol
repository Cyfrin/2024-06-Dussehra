// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {ERC721URIStorage, ERC721} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract RamNFT is ERC721URIStorage {
    error RamNFT__NotOrganiser();
    error RamNFT__NotChoosingRamContract();

    // https://medium.com/illumination/16-divine-qualities-of-lord-rama-24c326bd6048
    struct CharacteristicsOfRam {
        address ram;
        bool isJitaKrodhah;
        bool isDhyutimaan;
        bool isVidvaan;
        bool isAatmavan;
        bool isSatyavaakyah;
    }

    uint256 public tokenCounter;
    address public organiser;
    address public choosingRamContract;

    mapping(uint256 tokenId => CharacteristicsOfRam) public Characteristics;

    modifier onlyOrganiser() {
        if (msg.sender != organiser) {
            revert RamNFT__NotOrganiser();
        }
        _;
    }

    modifier onlyChoosingRamContract() {
        if (msg.sender != choosingRamContract) {
            revert RamNFT__NotChoosingRamContract();
        }
        _;
    }

    constructor() ERC721("RamNFT", "RAM") {
        tokenCounter = 0;
        organiser = msg.sender;
    }

    function setChoosingRamContract(address _choosingRamContract) public onlyOrganiser {
        choosingRamContract = _choosingRamContract;
    }
    
    function mintRamNFT(address to) public {
        uint256 newTokenId = tokenCounter++;
        _safeMint(to, newTokenId);

        Characteristics[newTokenId] = CharacteristicsOfRam({
            ram: to,
            isJitaKrodhah: false,
            isDhyutimaan: false,
            isVidvaan: false,
            isAatmavan: false,
            isSatyavaakyah: false
        });
    }

    function updateCharacteristics(
        uint256 tokenId,
        bool _isJitaKrodhah,
        bool _isDhyutimaan,
        bool _isVidvaan,
        bool _isAatmavan,
        bool _isSatyavaakyah
    ) public onlyChoosingRamContract {

        Characteristics[tokenId] = CharacteristicsOfRam({
            ram: Characteristics[tokenId].ram,
            isJitaKrodhah: _isJitaKrodhah,
            isDhyutimaan: _isDhyutimaan,
            isVidvaan: _isVidvaan,
            isAatmavan: _isAatmavan,
            isSatyavaakyah: _isSatyavaakyah
        });
    }

    function getCharacteristics(uint256 tokenId) public view returns (CharacteristicsOfRam memory) {
        return Characteristics[tokenId];
    }
    
    function getNextTokenId() public view returns (uint256) {
        return tokenCounter;
    }
}

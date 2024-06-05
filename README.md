<p align="center">
<img src="https://allpngfree.com/apf-prod-storage-api/storage/thumbnails/god-ram-ai-png-transparent-image-download-thumbnail-1705730672.jpg" width="300" alt="Dussehra">
<br/>

# Contest Details

### Prize Pool

- High - 100xp
- Medium - 20xp
- Low - 2xp

- Starts: 
- Ends: 

### Stats

- nSLOC: 218
- Complexity Score: 145

# Dussehra

## Disclaimer

_This code was created for Codehawks as the first flight. It is made with bugs and flaws on purpose._
_Don't use any part of this code without reviewing it and audit it._

_Created by Naman Gautam_

# About

- Dussehra, a major Hindu festival, commemorates the victory of Lord Rama, the seventh avatar of Vishnu, over the demon king Ravana. The festival symbolizes the victory of good over evil, righteousness over wickedness. According to the epic Ramayana, Ravana kidnaped Rama's wife, Sita, leading to a brutal battle between Rama and his allies against Ravana and his forces. After a ten-day battle, Rama emerged victorious by slaying Ravana, marking the victory of virtue and the restoration of dharma. Dussehra is celebrated with grand processions, reenactments of Rama's victory, and the burning of effigies of Ravana, symbolizing the destruction of evil forces. It signifies the enduring significance of courage, righteousness, and the eventual victory of light over darkness.

- The `Dussehra` protocol allows user to participate in the event of Dussehra. The protocol is divided into three contracts: `ChoosingRam`, `Dussehra`, and `RamNFT`. The `ChoosingRam` contract allows users to increase their values and select Ram but only if they have not selected Ram before. The `Dussehra` contract allows users to enter the people who like Ram, kill Ravana, and withdraw their rewards. The `RamNFT` contract allows `Dussehra contract` to mint Ram NFTs, update the characteristics of the NFTs, and get the characteristics of the NFTs.

## ChoosingRam.sol

This contract allows users to increase their values and select as Ram if all characteristics are true. if the user has not selected Ram before 12th October 2024. then, Organiser can select Ram if not selected.

- `increaseValuesOfParticipants` - Allows users to increase their values(or characteristics) and become Ram for the event and never update the values again after 12th October 2024.
- `selectRamIfNotSelected` - Allows the organiser to select Ram if not selected by the user.

## Dussehra.sol

This contract allows users to enter the people who like Ram, kill Ravana, and withdraw their rewards.

- `enterPeopleWhoLikeRam` - Allows users to enter in the event like Ram by giving entry fee and receive the ramNFT.
- `killRavana` - Allows users to kill Ravana and Organiser will get half of the total amount collected in the event. this function will only work after 12th October 2024 and before 13th October 2024.
- `withdraw` - Allows ram to withdraw their rewards.

## RamNFT.sol

This contract allows the Dussehra contract to mint Ram NFTs, update the characteristics of the NFTs, and get the characteristics of the NFTs.

- `setChoosingRamContract` - Allows the organiser to set the choosingRam contract. 
- `mintRamNFT` - Allows the Dussehra contract to mint Ram NFTs.
- `updateCharacteristics` - Allows the ChoosingRam contract to update the characteristics of the NFTs. 
- `getCharacteristics` - Allows the user to get the characteristics of the NFTs.
- `getNextTokenId` - Allows the users to get the next token id.

NFTs are minted with the following characteristics:
- `ram`: address of user
- `isJitaKrodhah`: false      // _JitaKrodhah means one who has conquered anger_
- `isDhyutimaan`: false       // _Dhyutimaan means one who is intelligent_
- `isVidvaan`: false          // _Vidvaan means one who is knowledgeable_
- `isAatmavan`: false         // _Aatmavan means one who is self-controlled_
- `isSatyavaakyah`: false     // _Satyavaakyah means one who speaks the truth_

# Getting Started

## Requirements

- [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
  - You'll know you did it right if you can run `git --version` and you see a response like `git version x.x.x`
- [foundry](https://getfoundry.sh/)
  - You'll know you did it right if you can run `forge --version` and you see a response like `forge 0.2.0 (816e00b 2023-03-16T00:05:26.396218Z)`

```
git clone 
cd 
```

# Usage

## Testing

```
forge test
```

### Test Coverage

```
forge coverage
```

and for coverage based testing:

```
forge coverage --report debug
```

# Audit Scope Details
- In Scope:

```
├── src
│   ├── ChoosingRam.sol
│   ├── Dussehra.sol
│   ├── RamNFT.sol
```

## Compatibilities

- Solc Version: `0.8.20`
- Chain(s) to deploy contract to:
  - Ethereum
  - zksync
  - Arbitrum
  - BNB

# Roles

Organiser - Organiser of the event and Owner of RamNFT contract

User - User who wants to participate in the event 

Ram - User who has selected Ram for the event

# Known Issues

None
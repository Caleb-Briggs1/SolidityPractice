// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../node_modules/@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "../node_modules/@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "../node_modules/@openzeppelin/contracts/access/Ownable.sol";

//note: could make this thing pausable and include some reentrancyGuard for good security

interface V1NFT is IERC721 {
}
interface V2NFT is IERC721 {
}

contract FYTE is ERC20, Ownable {
    

    address public V2Address=0xB0871457eD9812e56083072E8251991e58377C84; //these are just temporary values for testing
    address public V1Address = 0x449d0c8BB64269b263e8670F04Ba1059f12c38D2;
    uint256 public V1ClaimAmount=1;
    uint256 public V2ClaimAmount=1;
    uint256 public FYTECost = 1 ether;
    mapping (address=>uint256) private ClaimDate; //mapping of addresses to time last claimed succuesfully. 
    uint256 private WaitTime  = 60*60*24;  //seconds in a day-- wait 24 hours between claims

   

    constructor(string memory name, string memory symbol) ERC20(name,symbol) {
        //
    }
    //Allows users to claim a set amount of tokens daily depending on whether they own a V1 or V2 NFT
    function Claim() public {
       
        uint256 lastClaimDate = ClaimDate[msg.sender];
        if(block.timestamp-lastClaimDate >= WaitTime) { //use timestamp on a large timescale is safe.
            ClaimDate[msg.sender] = block.timestamp; //update the date first 
            V1NFT V1Contract = V1NFT(V1Address);
            V2NFT V2Contract = V2NFT(V2Address);
            //we control the location of these contracts, so we don't have to worry about re-entrancy
            uint256 NFTCount1 = V1Contract.balanceOf(msg.sender); 
            uint256 NFTCount2 = V2Contract.balanceOf(msg.sender);
            if(NFTCount1 * V1ClaimAmount > 0) {
                _mint(msg.sender, NFTCount1 * V1ClaimAmount);
            }
            if(NFTCount2 * V2ClaimAmount > 0) {
                _mint(msg.sender, NFTCount2 * V2ClaimAmount);
            }
            

            //mint tokens based on V1 and V2 tokens.
        }
        else {
            return; //already claimed their tokens. Maybe change this to return time until they can claim in the future if neccesary
        }


    }
    //Allows users to “buy” a set number of tokens at a fixed price. 
    function Buy(uint256 mintAmount) public payable { 
        //NOTE: Solidity 0.8.0 and above will check for overflows, so we are safe to multiply inputAmount

        if(msg.value >= mintAmount * FYTECost) {
             _mint(msg.sender,mintAmount);
        }
        
    }
    function OwnerMint(uint256 mintAmount) public onlyOwner {
         _mint(msg.sender,mintAmount);
    }
    //allows changing of variables, will include other ones over time
    function changeV1Address(address NewV1Address) public onlyOwner {
       V1Address = NewV1Address;
    }
    function changeV2Address(address NewV2Address) public onlyOwner {
       V2Address = NewV2Address;
    }
    function changeV1Claim(uint256 NewV1Claim) public onlyOwner {
       V1ClaimAmount =NewV1Claim;
    }
    function changeV2Claim(uint256 NewV2Claim) public onlyOwner {
       V2ClaimAmount =NewV2Claim;
    }
    function changeFYTECost(uint256 NewFYTECost) public onlyOwner {
        FYTECost = NewFYTECost;
    }
    function changeWaitTime(uint256 NewWaitTime) public onlyOwner {
        WaitTime = NewWaitTime;
    }
    



   
}
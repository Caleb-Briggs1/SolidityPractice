
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../node_modules/@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "../node_modules/@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "../node_modules/@openzeppelin/contracts/access/Ownable.sol";
import "../node_modules/@openzeppelin/contracts/finance/PaymentSplitter.sol";

//note: could make this thing pausable and include some reentrancyGuard for good security

contract FYTE is ERC20, Ownable,PaymentSplitter {
    address public V2Address; //these are just temporary values for testing
    address public V1Address;
    uint256 public V1ClaimAmount=1;
    uint256 public V2ClaimAmount=1;
    uint256 public FYTECost = 1 ether;
    mapping (address=>uint256) private ClaimDate; //mapping of addresses to time last claimed succuesfully. 
    uint256 private WaitTime  = 60*60*24;  //seconds in a day-- wait 24 hours between claims
    bool private _pausedBuy;
    bool private _pausedClaim;
    constructor(string memory name, string memory symbol, address[] memory payees, uint256[] memory shares) ERC20(name,symbol) PaymentSplitter(payees, shares) {
        _pausedBuy = false;
        _pausedClaim = false;
    }
    function pauseBuy() public onlyOwner {
        _pausedBuy=true;
    }
    function unpauseBuy() public onlyOwner {
        _pausedBuy=false;
    }
    function pauseClaim() public onlyOwner {
        _pausedClaim=true;
    }
    function unpauseClaim() public onlyOwner {
        _pausedClaim=false;
    }
    //NOTE:
        //more test functions for all the only owner functions
        //gas optimzie to make it smaller
        //check if wait time being a function 

    //Allows users to claim a set amount of tokens daily depending on whether they own a V1 or V2 NFT
    function Claim() public {
        require(! (_pausedClaim),"Claim is paused");
        uint256 lastClaimDate = ClaimDate[msg.sender];
        require(block.timestamp-lastClaimDate >= WaitTime, "Not yet ready to claim"); //use timestamp on a large timescale is safe.
        ClaimDate[msg.sender] = block.timestamp; //update the date first 
        //we control the location of these contracts, so we don't have to worry about re-entrancy
        uint256 NFTCount1 = IERC721(V1Address).balanceOf(msg.sender); 
        uint256 NFTCount2 = IERC721(V2Address).balanceOf(msg.sender);
        uint256 totalMint = (NFTCount1 * V1ClaimAmount)+ (NFTCount2 * V2ClaimAmount);
        _mint(msg.sender, totalMint); //minting zero seems to cost almost nothing extra based on testing
    }
    //Allows users to “buy” a set number of tokens at a fixed price. 
    function Buy(uint256 mintAmount) public payable { 
        //NOTE: Solidity 0.8.0 and above will check for overflows, so we are safe to multiply inputAmount
        require(! (_pausedBuy),"Buy is paused");
        require(msg.value >= mintAmount * FYTECost, "Not enough ether sent");
        _mint(msg.sender,mintAmount);
        
    }
    function OwnerMint(uint256 mintAmount) public onlyOwner {
         _mint(msg.sender,mintAmount);
    }
    function timeToClaim() public view returns (uint256) {
        uint256 time = (block.timestamp-ClaimDate[msg.sender]);
        if(time >WaitTime) {
            return 0;
        }
        return WaitTime - time;
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




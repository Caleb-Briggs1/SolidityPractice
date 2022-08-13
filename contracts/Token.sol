pragma solidity ^0.8.0;

import "../node_modules/@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "../node_modules/@openzeppelin/contracts/access/Ownable.sol";



contract Token is ERC721, Ownable {

    struct Fighter {
        uint256 lastCollect;
        uint256 maxUpdateTime;
        bool alive;
        uint256 recoverTime; //amount of time before fighter comes back to life
        uint8 power; //power determines number of free gems 
        uint256 deathTime; //time that this died.
    }

    uint256 tokenId; //default to zero

    mapping (uint256=>Fighter) private _fighterDetails;

    constructor(string memory name, string memory symbol) ERC721(name,symbol) {
        //
    }
    function tokenID() public view returns(uint256) {
        return tokenId;
    }
    
    function mint(uint256 maxUpdateTime,uint256 recoverTime,uint8 power) public {
        //block.timestamp gives the time, but be careful since it can be manipulated
        //by around 15 seconds
        _safeMint(msg.sender, tokenId);
        _fighterDetails[tokenId] = Fighter(block.timestamp,maxUpdateTime,true,recoverTime,power,0);
        tokenId= tokenId + 1;
        
        


    }
    //returns fighter from tokenID
    function getTokenDetails(uint256 id) view public returns (Fighter memory)  {
        require (id < tokenId,"id too large");
        require (id >=0,"id too small");
        return _fighterDetails[id];

    }
    //fight
    function fight(Fighter memory fighter1, Fighter memory fighter2) public isAlive(fighter1) isAlive(fighter2) { 
        //both fighters must be alive to fight
        //some code that makes the two things fight against each other


    }
    function kill(uint256 id) public isAlive(_fighterDetails[id]) {
        _fighterDetails[id].alive = false;
        _fighterDetails[id].deathTime = block.timestamp; //set death time to now
    }
    function revive(uint256 id) public {
        require(block.timestamp- _fighterDetails[id].deathTime > _fighterDetails[id].recoverTime, "Fighter not ready to revive");
        _fighterDetails[id].alive = true;
        //send back to life. 
        _fighterDetails[id].power -= 1; //weak power
        if(_fighterDetails[id].power < 0) {
            _fighterDetails[id].power = 0; //can't be worse than 0. 
        }
       

    }
    modifier isAlive(Fighter memory fighter) {
        require(fighter.alive, "Fighter is dead");
        _;
    }
    //gets all the tokens a given user owns
    function getAllTokensFromUser(address user) public view returns (uint256[] memory) {
        uint256 i;
        uint8 j =0;
        uint256[] memory res = new uint256[](balanceOf(user));
        if(res.length == 0) {
            return res; //
        }
        for (i=0; i < tokenId; i+=1){
            if(ownerOf(i) == user) {
                res[j++] = i;
                
                
            }
        }
        return res;
    }
   
}
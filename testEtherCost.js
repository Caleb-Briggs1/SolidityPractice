
const gemToken = artifacts.require("FYTE")
const v1 = artifacts.require("V1")
const v2 = artifacts.require("V2")
let gems;
let v1NFT;
let v2NFT;

const Web3 = require("web3")
const web3 = new Web3("http://localhost:7545")


async function init() {
    gems = await gemToken.deployed();
    v1NFT = await v1.deployed();
    v2NFT = await v2.deployed();
    await gems.changeV1Address(v1NFT.address) //change address
    await gems.changeV2Address(v2NFT.address) //change address
    
}

contract("TokenTest", async accounts => {
  
    it("Claim tokens v1", async () => {
        const [firstAccount,secondAccount,thirdAccount] = accounts;

        console.log("test")
        await init()
        
        for(let i = 0; 100 > i; i++) {
            await gems.Buy(0,{from:thirdAccount })
            //await gems.Claim({from:thirdAccount })
            //console.log("test 2")
        }
       
        
    });
    


  
  
  

})

function delay(delayInms) {
    return new Promise(resolve => {
      setTimeout(() => {
        resolve(2);
      }, delayInms);
    });
  }
  
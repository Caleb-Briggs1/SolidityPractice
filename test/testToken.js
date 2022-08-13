
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
        const [firstAccount,secondAccount] = accounts;


        await init()
        
        //console.log(firstAccount)
        await v1NFT.mint(firstAccount,0);
        //console.log(await v1NFT.balanceOf(firstAccount))
        assert.equal(await v1NFT.balanceOf(firstAccount),1,"didn't mint any tokens")
        await gems.Claim({from:firstAccount})
        assert.equal( (await gems.balanceOf(firstAccount)), 1, "didn't mint right number of tokens")
        await gems.Claim({from:firstAccount})
        assert.equal( (await gems.balanceOf(firstAccount)), 1, "minted tokens even though wait time was not reached")
        await gems.changeWaitTime(1); //1 second of wait time between calls
        await delay(1500);
        await gems.Claim({from:firstAccount});
        assert.equal( (await gems.balanceOf(firstAccount)), 2, "didn't mint after delay")
       
        
    });
    it("Claim tokens v2", async () => {
        const [firstAccount,secondAccount] = accounts;


        await init()
        //console.log(firstAccount)
        await v2NFT.mint(secondAccount,0);
        //console.log(await v1NFT.balanceOf(firstAccount))
        assert.equal(await v2NFT.balanceOf(secondAccount),1,"didn't mint any tokens")
        await gems.Claim({from:secondAccount})
        assert.equal( (await gems.balanceOf(secondAccount)), 1, "didn't mint right number of tokens")
        await gems.Claim({from:secondAccount})
        assert.equal( (await gems.balanceOf(secondAccount)), 1, "minted tokens even though wait time was not reached")
        await gems.changeWaitTime(1); //1 second of wait time between calls
        await delay(1500);
        await gems.Claim({from:secondAccount});
        assert.equal( (await gems.balanceOf(secondAccount)), 2, "didn't mint after delay")
       
        
    });
    
    it("Buy tokens", async () => {
      const [firstAccount,secondAccount] = accounts;

      
      await init()
      initTokens = (await gems.balanceOf(firstAccount)).toNumber()
      //console.log(firstAccount)
      await gems.Buy(2,{from:firstAccount, value: 2 * Math.pow(10,18)});
      assert.equal(await gems.balanceOf(firstAccount), initTokens + 2, "Didn't mint tokens correctly")

      /*
      await gems.Buy(100,{from:firstAccount, value: 100 * Math.pow(10,18)});
      assert.equal(await gems.balanceOf(firstAccount), 2, "Didn't mint tokens correctly")
      transaction will fail if funds are not there, which is good */

      await gems.Buy(1,{from:firstAccount, value: 1 * Math.pow(10,18)});
      assert.equal(await gems.balanceOf(firstAccount), initTokens+3, "Didn't mint tokens correctly")
      
  });
  it("Owner mint tokens", async () => {
    const [firstAccount,secondAccount] = accounts;


    await init()
    initTokens = (await gems.balanceOf(firstAccount)).toNumber()
    await gems.OwnerMint(15, {from:firstAccount})
    assert.equal( (await gems.balanceOf(firstAccount)).toNumber(), initTokens+ 15, "Didn't mint tokens correctly") //has 5 tokens from the previous test
    try {
      await gems.OwnerMint(50, {from:secondAccount})
      assert.equal(await gems.balanceOf(secondAccount), 0, "Minted even though not owner")
    }
    catch {
      //if transaction is reverted, that is good
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
  
const gemToken = artifacts.require("FYTE")
const v1 = artifacts.require("V1")
const v2 = artifacts.require("V2")

module.exports = async function(deployer) {
    await deployer.deploy(gemToken,"FYTE","$FYTE",["0xb0de9ADbF6401247cf5C70Bb2164C6Da440A8ceb","0x47F7042a8dec01DD1Ebd86C2032Be66F220dd2De"],[10,90]);
    await deployer.deploy(v1,"v1","$v1");
    await deployer.deploy(v2,"v2","$v2");
    let gems = await gemToken.deployed();
    
    let v1NFT = await v1.deployed();
    let v2NFT = await v2.deployed();


    /*
    await tokenInstance.mint(10000,1,1)
    console.log("==============")
    console.log ((await (tokenInstance.tokenID())).toString())
    console.log("==============")
    */
}

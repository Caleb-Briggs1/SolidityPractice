const gemToken = artifacts.require("FYTE")
const v1 = artifacts.require("V1")
const v2 = artifacts.require("V2")

module.exports = async function(deployer) {
    await deployer.deploy(gemToken,"FYTE","$FYTE",["0x01FB9FE99DBf58e7c8c3bBC8C2A5093BF5d39A7D","0x16fE6dfb4ddCeFF03Be66208e592A2A135B08E58"],[10,90]);
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

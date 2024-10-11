const { ethers } = require("hardhat");


module.exports = async () => {

    const escrow = await ethers.getContractFactory("Escrow");
    
    // deploy evlToken
    const escrowInst = await escrow.deploy();
    await escrowInst.waitForDeployment();
    console.log(`### escrow deployed at ${escrowInst.target}`);

    return true;
};
module.exports.tags = ["Escrow"];
module.exports.id = "Escrow";

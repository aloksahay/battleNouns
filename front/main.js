const { ethers } = require("ethers");

const token_a = "0xa4bf4104ec0109591077Ee5F4a2bFD13dEE1Bdf8"
const token_b = "0x370BAe51E225D820cb7946e0Dd5b225FE5A65803"

async function main() {
  
  // const deployer = await ethers.getSigners();
  // console.log(deployer)

  const Battle = await ethers.getContractFactory("../contract/contracts/Battle.sol");
  console.log(Battle);

//   const contract = await Battle.deploy();
//   console.log(contract.address)
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

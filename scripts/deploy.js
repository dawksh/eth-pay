
const { ethers } = require("hardhat");
const hre = require("hardhat");

async function main() {

  const PayperContract = await hre.ethers.getContractFactory("Payper");
  const payper = await PayperContract.deploy();

  await payper.deployed();


  console.log("recepient deployed to:", payper.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });

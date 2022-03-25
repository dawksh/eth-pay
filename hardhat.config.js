require("@nomiclabs/hardhat-waffle");
require('dotenv').config();

task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});

module.exports = {
  solidity: "0.8.4",
  networks: {
  hardhat: {
    forking: {
      url: process.env.API_URL,
    }
  },
  mainnet: {
      url: "http://127.0.0.1:8545/",
      accounts: [process.env.LOCAL_KEY]
    },
    
  mumbai: {
      url: process.env.MUMBAI_ENDPOINT,
      accounts: [process.env.LOCAL_KEY]
    }
}
};

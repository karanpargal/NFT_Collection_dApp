const hardhat = require("hardhat");
require("dotenv").config();

async function main() {
  const whitelistContract = process.env.WHITELIST_CONTRACT_ADDRESS;
  const metadataURL = process.env.METADATA_URL;

  const cryptoDevsContract = await ethers.getContractFactory("CryptoDevs");
  const deployedCryptoDevsContract = await cryptoDevsContract.deploy(
    metadataURL,
    whitelistContract
  );

  console.log("Address of the contract: ", deployedCryptoDevsContract.address);
}

main()
  .then(() => {
    process.exit(0);
  })
  .catch((e) => {
    console.error(e);
    process.exit(1);
  });

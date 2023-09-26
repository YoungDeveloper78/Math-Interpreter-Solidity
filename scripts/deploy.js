const hre = require("hardhat");
const fs = require('fs');
const Library = "MathematicsInterpreterLibrary";
const ContractName = "Test";

async function main() {
  // Deploy the library first
  const MathLibrary = await hre.ethers.getContractFactory(Library);
  const mathLibrary = await MathLibrary.deploy();
  // Deploy the contract and link it to the library
  const Contract = await hre.ethers.getContractFactory(ContractName, {
    libraries: {
      MathematicsInterpreterLibrary: mathLibrary.target, // Link the library to the contract
    },
  });
  const contract = await Contract.deploy();

  const addresses = {
    "TestContract": contract.target,
    "Lib": mathLibrary.target,
  };

  fs.writeFileSync("./data/addresses.json", JSON.stringify(addresses));
  console.log("Contracts deployed");
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });

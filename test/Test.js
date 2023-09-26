const {
  loadFixture,
} = require("@nomicfoundation/hardhat-toolbox/network-helpers");
const { expect } = require("chai");

describe("MathExpression", function () {
  
  
  
  async function deployMathExpression() {
    
    
  const MathLibrary = await hre.ethers.getContractFactory("MathematicsInterpreterUintLibrary");
  const mathLibrary = await MathLibrary.deploy();
  
  const Contract = await hre.ethers.getContractFactory("Test", {
    libraries: {
      MathematicsInterpreterLibrary: mathLibrary.target, 
    },
  });

    
    const contract = await Contract.deploy();

    return { contract };
  }

  describe("Deployment", function () {
    it("expression 1", async function () {
      const { contract } = await loadFixture(deployMathExpression);
      const result=await contract.calculator("10+4^2-3")
      console.log(result);
      expect(result.toString()).to.equal("23");
    });

    it("expression 2", async function () {
      const { contract } = await loadFixture(deployMathExpression);

      const result=await contract.calculator("(111111110*17^(12-3)-12)")
      expect(result.toString()).to.equal("13176430590124581658");
    });

    it("expression 3", async function () {
      const { contract } = await loadFixture(deployMathExpression);

      const result=await contract.calculator("(1000-888)*332/12*47^(2+3)")
      expect(result.toString()).to.equal("710510831686");
      /** 
       * @notice The expected result of this expression in regular arithmetic is 710663728357,
       *         but due to the absence of floating-point numbers in Solidity and the use of
       *         the `div` operator, the result is calculated using integer arithmetic. Therefore,
       *         the result provided here, 710510831686, is the closest possible integer result
       *         within the limitations of integer calculations.
       * 
       * @notice We are aware of this limitation and intend to address it in a future update to
       *         provide more precise arithmetic calculations that align with regular arithmetic.
       */
    });
  });
});

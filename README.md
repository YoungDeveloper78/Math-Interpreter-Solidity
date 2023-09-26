
# Mathematics Interpreter Library

    A Solidity library for mathematical expression interpretation.
    
## Getting Started

### Prerequisites

Before you begin, ensure you have met the following requirements:

- [Node.js](https://nodejs.org/) installed
- [Hardhat](https://hardhat.org/) installed globally

### Installation

    1. Clone the repository:

        git clone https://github.com/yourusername/your-project.git

        Navigate to the project directory:

        cd your-project

    2. Install the project dependencies:

        npm install

## Usage

    1.Running Tests

        To run tests for the project, use the following command:

            npm run test

            npx hardhat coverage

            These command will execute tests using Hardhat.
    2.Using inside SmartContract
        To use this library in your Solidity smart contract:

        Import the library at the beginning of your contract file:

            // Import the MathematicsInterpreterLibrary
            import "./MathematicsInterpreterLibrary.sol";

## Deployment

    To deploy the project on the local network, use the following command:

    npm run deploy

    This command will run the deployment script using Hardhat.

## License

    This project is licensed under the MIT License. See the LICENSE file for details.
    

## Features

    Calculate the result of mathematical expressions containing operators such as +, -, *, /, %, and ^, as well as parentheses for defining the order of operations.
    Supports integer arithmetic, handling both positive and negative numbers.
    Extracts variables (unsigned integers) from input strings.
    Handles negative numbers and parentheses effectively.

## Important Notice

    Solidity does not support floating-point numbers. Currently, this library uses integer arithmetic, so there may be minor discrepancies in the results when compared to floating-point calculations. We plan to address this in a future update.

For any questions or support, please reach out to [parsaDeveloperBLC@gmail.com].



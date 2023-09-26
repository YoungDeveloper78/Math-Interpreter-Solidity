// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "./MathematicsInterpreterLibrary.sol";

contract Test {
    using MathematicsInterpreterLibrary for string;

    function calculator(string memory expression) public pure returns (int) {
        return expression.calculateExpression();
    }
}

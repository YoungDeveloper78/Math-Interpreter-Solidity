// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title MathematicsInterpreterLibrary
 * 
 * @author YoungDeveloper78

 * @notice This library provides functions for mathematical expression interpretation.
 *
 * @dev This library can be used to calculate the result of mathematical expressions
 *      containing operators such as +, -, *, /, %, and ^, as well as parentheses for
 *      defining the order of operations.
 *
 * @notice Users of this library should be cautious when using it with untrusted input
 *      strings, as it may lead to unexpected results or vulnerabilities if not used
 *      properly.
 *
 * @notice This library is provided "as is," and the author makes no guarantees about
 *      its correctness or suitability for any particular purpose.
 */
library MathematicsInterpreterUintLibrary {
    /**
     * @notice Calculates the result of a mathematical expression.
     * @param input The input string containing the mathematical expression
     * @return The result of the mathematical expression as an unsigned integer (uint).
     */
    function calculateExpression(
        string memory input
    ) public pure returns (uint) {
        bytes memory inputBytes = bytes(input);
        uint[] memory tokens = new uint[](0);
        bytes1[] memory operators = new bytes1[](0);

        for (uint i = 0; i < inputBytes.length; i++) {
            bytes1 c = inputBytes[i];
            if (c == bytes1(" ")) {
                continue;
            } else if (c == bytes1("(")) {
                operators = pushToOperators(operators, c);
            } else if (c == bytes1(")")) {
                while (
                    operators.length > 0 &&
                    operators[operators.length - 1] != bytes1("(")
                ) {
                    uint b = tokens[tokens.length - 1];
                    uint a = tokens[tokens.length - 2];
                    bytes1 op = operators[operators.length - 1];
                    uint result = calculate(a, b, op);
                    tokens = popFromTokens(tokens);
                    tokens = popFromTokens(tokens);
                    tokens = pushToTokens(tokens, result);
                    operators = popFromOperators(operators);
                }
                operators = popFromOperators(operators); // Pop '('
            } else if (c == bytes1("^")) {
                // Handle exponentiation
                operators = pushToOperators(operators, c);
            } else if (
                c == bytes1("+") ||
                c == bytes1("-") ||
                c == bytes1("*") ||
                c == bytes1("/") ||
                c == bytes1("%")
            ) {
                while (
                    operators.length > 0 &&
                    hasPrecedence(c, operators[operators.length - 1])
                ) {
                    uint b = tokens[tokens.length - 1];
                    uint a = tokens[tokens.length - 2];
                    bytes1 op = operators[operators.length - 1];
                    uint result = calculate(a, b, op);
                    tokens = popFromTokens(tokens);
                    tokens = popFromTokens(tokens);
                    tokens = pushToTokens(tokens, result);
                    operators = popFromOperators(operators);
                }
                operators = pushToOperators(operators, c);
            } else {
                uint number = 0;
                bool isNegative = false;

                if (
                    c == bytes1("-") &&
                    (i == 0 || inputBytes[i - 1] == bytes1("("))
                ) {
                    isNegative = true;
                    i++;
                }

                while (
                    i < inputBytes.length &&
                    uint8(inputBytes[i]) >= 48 &&
                    uint8(inputBytes[i]) <= 57
                ) {
                    number = number * 10 + uint(uint8(inputBytes[i]) - 48);
                    i++;
                }
                i--;

                tokens = pushToTokens(tokens, number);
            }
        }

        while (operators.length > 0) {
            uint b = tokens[tokens.length - 1];
            uint a = tokens[tokens.length - 2];
            bytes1 op = operators[operators.length - 1];
            uint result = calculate(a, b, op);
            tokens = popFromTokens(tokens);
            tokens = popFromTokens(tokens);
            tokens = pushToTokens(tokens, result);
            operators = popFromOperators(operators);
        }

        require(tokens.length == 1, "Invalid expression");
        return tokens[0];
    }

    function pushToOperators(
        bytes1[] memory operators,
        bytes1 item
    ) private pure returns (bytes1[] memory) {
        bytes1[] memory newOperators = new bytes1[](operators.length + 1);
        for (uint i = 0; i < operators.length; i++) {
            newOperators[i] = operators[i];
        }
        newOperators[operators.length] = item;
        return newOperators;
    }

    function popFromOperators(
        bytes1[] memory operators
    ) private pure returns (bytes1[] memory) {
        require(operators.length > 0, "Operators underflow");
        bytes1[] memory newOperators = new bytes1[](operators.length - 1);
        for (uint i = 0; i < newOperators.length; i++) {
            newOperators[i] = operators[i];
        }
        return newOperators;
    }

    function pushToStack(
        bytes32[] memory stack,
        bytes1 item
    ) private pure returns (bytes32[] memory) {
        bytes32[] memory newStack = new bytes32[](stack.length + 1);
        for (uint i = 0; i < stack.length; i++) {
            newStack[i] = stack[i];
        }
        newStack[stack.length] = bytes32(item);
        return newStack;
    }

    function popFromStack(
        bytes32[] memory stack
    ) private pure returns (bytes32[] memory) {
        require(stack.length > 0, "Stack underflow");
        bytes32[] memory newStack = new bytes32[](stack.length - 1);
        for (uint i = 0; i < newStack.length; i++) {
            newStack[i] = stack[i];
        }
        return newStack;
    }

    function pushToTokens(
        uint[] memory tokens,
        uint item
    ) private pure returns (uint[] memory) {
        uint[] memory newTokens = new uint[](tokens.length + 1);
        for (uint i = 0; i < tokens.length; i++) {
            newTokens[i] = tokens[i];
        }
        newTokens[tokens.length] = item;
        return newTokens;
    }

    function popFromTokens(
        uint[] memory tokens
    ) private pure returns (uint[] memory) {
        require(tokens.length > 0, "Tokens underflow");
        uint[] memory newTokens = new uint[](tokens.length - 1);
        for (uint i = 0; i < newTokens.length; i++) {
            newTokens[i] = tokens[i];
        }
        return newTokens;
    }

    /**
     * @notice Checks if one operator has precedence over another.
     * @param op1 The first operator.
     * @param op2 The second operator.
     * @return True if op1 has precedence over op2, false otherwise.
     */
    function hasPrecedence(bytes1 op1, bytes1 op2) private pure returns (bool) {
        if (op2 == bytes1("(") || op2 == bytes1(")")) {
            return false;
        }
        if (
            (op1 == bytes1("*") ||
                op1 == bytes1("/") ||
                op1 == bytes1("^") ||
                op1 == bytes1("%")) &&
            (op2 == bytes1("+") || op2 == bytes1("-"))
        ) {
            return false;
        } else {
            return true;
        }
    }

    /**
     * @notice Performs a calculation with two unsigned integers and an operator.
     * @param a The first unsigned integer.
     * @param b The second unsigned integer.
     * @param op The operator (+, -, *, /, ^, %).
     * @return The result of the calculation as an unsigned integer (uint).
     */
    function calculate(uint a, uint b, bytes1 op) private pure returns (uint) {
        if (op == bytes1("+")) {
            return a + b;
        } else if (op == bytes1("-")) {
            return a - b;
        } else if (op == bytes1("*")) {
            return a * b;
        } else if (op == bytes1("/")) {
            require(b != 0, "Cannot divide by zero");
            return a / b;
        } else if (op == bytes1("^")) {
            uint result = 1;
            for (uint i = 0; i < b; i++) {
                result *= a;
            }
            return result;
        } else if (op == bytes1("%")) {
            require(b != 0, "Cannot modulo by zero");
            return a % b;
        }
        revert("Invalid operator");
    }

    /**
     * @notice Extracts variables (unsigned integers) from an input byte string.
     * @param inputBytes The input byte string.
     * @return An array of extracted unsigned integers.
     */
    function extractVariables(
        bytes memory inputBytes
    ) internal pure returns (uint8[] memory) {
        uint8[] memory xNumbers = new uint8[](inputBytes.length); // Maximum possible number of x numbers
        uint8 xNumberCount = 0;
        uint8 currentNumber = 0;
        bool isParsingXNumber = false;

        for (uint i = 0; i < inputBytes.length; i++) {
            if (isParsingXNumber) {
                if (
                    inputBytes[i] >= bytes1("0") && inputBytes[i] <= bytes1("9")
                ) {
                    currentNumber =
                        currentNumber *
                        10 +
                        uint8(inputBytes[i]) -
                        uint8(bytes1("0"));
                } else {
                    xNumbers[xNumberCount++] = currentNumber;
                    currentNumber = 0;
                    isParsingXNumber = false;
                }
            }

            if (inputBytes[i] == bytes1("x")) {
                isParsingXNumber = true;
            }
        }

        // If an x number is at the end of the string
        if (isParsingXNumber) {
            xNumbers[xNumberCount++] = currentNumber;
        }

        // Resize the xNumbers array to the actual number of x numbers
        assembly {
            mstore(xNumbers, xNumberCount)
        }

        return xNumbers;
    }

    /**
     * @notice Removes variable tokens (unsigned integers) from an input byte string.
     * @param inputBytes The input byte string.
     * @return The modified input byte string with variables removed.
     */
    function removeXNumbers(
        bytes memory inputBytes
    ) internal pure returns (bytes memory) {
        bytes memory resultBytes = new bytes(inputBytes.length);
        uint resultLength = 0;

        for (uint i = 0; i < inputBytes.length; i++) {
            if (inputBytes[i] == bytes1("x")) {
                // Skip the "x" character
                resultBytes[resultLength++] = inputBytes[i];
                i++;
                // Skip the digits following "x"
                while (
                    i < inputBytes.length &&
                    inputBytes[i] >= bytes1("0") &&
                    inputBytes[i] <= bytes1("9")
                ) {
                    i++;
                }
                // Move the index back by one to handle the character after "x" properly
                i--;
            } else {
                resultBytes[resultLength++] = inputBytes[i];
            }
        }

        // Trim the resultBytes to the actual length
        bytes memory result = new bytes(resultLength);
        for (uint j = 0; j < resultLength; j++) {
            result[j] = resultBytes[j];
        }

        return result;
    }
}

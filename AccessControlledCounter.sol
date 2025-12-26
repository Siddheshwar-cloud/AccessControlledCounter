// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract AccessControlledCounter {
    //state variables.
    address public owner;
    uint256 public counter;
    mapping(address => bool) public operators;

    //Events
    event OperatorAdded(address indexed operator);
    event OperatorRemoved(address indexed operator);
    event CounterUpdated(address indexed operator, uint256 newValue);

    //modifiers
    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    modifier onlyOperator() {
        require(operators[msg.sender], "not Operator");
        _;
    }

    constructor() {
        owner = msg.sender;
        operators[msg.sender] = true; //owner is operator default
    }

    //Admin Functions
    function addOperator(address _operator) external onlyOwner {
        operators[_operator] = true;
        emit OperatorAdded(_operator);
    }

    function removeOperator(address _operator) external onlyOwner {
        operators[_operator] = false;
    }

    //core Logic
    function increment() external onlyOperator {
        counter += 1;
        emit CounterUpdated(msg.sender, counter);
    }

    function decrement() external onlyOperator {
        require(counter > 0, "Counter is zero");
        counter -= 1;
        emit CounterUpdated(msg.sender, counter);
    }
}

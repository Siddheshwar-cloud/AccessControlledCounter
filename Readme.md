<div align="center">

# AccessControlledCounter

### Enterprise-Grade Role-Based Access Control

[![Solidity](https://img.shields.io/badge/Solidity-^0.8.20-e6e6e6?style=for-the-badge&logo=solidity&logoColor=black)](https://soliditylang.org/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](https://opensource.org/licenses/MIT)
[![Ethereum](https://img.shields.io/badge/Ethereum-3C3C3D?style=for-the-badge&logo=Ethereum&logoColor=white)](https://ethereum.org/)

A production-ready smart contract implementing role-based access control for decentralized applications

---

</div>

## Overview

AccessControlledCounter is a Solidity smart contract that demonstrates clean separation of administrative and operational privileges. The contract maintains a simple counter that can only be modified by authorized operators, while the owner retains full control over who can be an operator.

Think of it as a permission system: one owner with administrative access, and multiple operators who can modify the counter.

<div align="center">

### Ideal For

**DAOs • Multi-Sig Operations • Enterprise dApps • Governance Systems • Collaborative Platforms**

</div>

---

## Key Features

<table>
<tr>
<td width="50%">

**Core Capabilities**
- Dual-role architecture separating admin and operator privileges
- Add or remove operators dynamically
- Strong access control using modifiers
- Protection against counter going below zero

</td>
<td width="50%">

**Technical Benefits**
- Event-driven design for complete audit trail
- Gas optimized with minimal storage
- Industry-standard access control patterns
- Built-in overflow protection via Solidity 0.8+

</td>
</tr>
</table>

---

## Architecture

<div align="center">

```
┌─────────────────────────────────────────┐
│           CONTRACT OWNER                │
│   (Deployment Address)                  │
│                                         │
│   • Add/Remove Operators                │
│   • Full Administrative Control         │
│   • Automatic Operator Status           │
└──────────────┬──────────────────────────┘
               │
               ▼
┌──────────────────────────────────────────┐
│          OPERATOR POOL                   │
│   (Multiple Authorized Addresses)       │
│                                          │
│   • Increment Counter                   │
│   • Decrement Counter                   │
│   • Emit State Changes                  │
└──────────────┬───────────────────────────┘
               │
               ▼
┌──────────────────────────────────────────┐
│         COUNTER STATE                    │
│   (uint256 - Publicly Readable)         │
│                                          │
│   • Zero Underflow Protection           │
│   • Overflow Safe (Solidity 0.8+)      │
└──────────────────────────────────────────┘
```

</div>

### Role System

| Role | Permissions | Auto-Granted | Transferable |
|------|-------------|--------------|--------------|
| **Owner** | Manage operators, Modify counter | On deployment | No (not implemented) |
| **Operator** | Modify counter only | If owner | Via owner action |

---

## Contract Interface

### State Variables

```solidity
address public owner;                      // Contract administrator
uint256 public counter;                    // The counter value (starts at 0)
mapping(address => bool) public operators; // Operator whitelist
```

### Events

```solidity
event OperatorAdded(address indexed operator);      
event OperatorRemoved(address indexed operator);    
event CounterUpdated(address indexed operator, uint256 newValue);
```

### Access Control Modifiers

```solidity
modifier onlyOwner()    // Restricts function to contract owner
modifier onlyOperator() // Restricts function to authorized operators
```

---

## Functions

### Administrative Functions

<table>
<tr>
<td width="50%">

#### addOperator

**Access**: Owner only  
**Purpose**: Grant operator privileges to an address  
**Emits**: `OperatorAdded`  
**Gas Cost**: Approximately 45,000

```solidity
function addOperator(address _operator) 
    external 
    onlyOwner
```

</td>
<td width="50%">

#### removeOperator

**Access**: Owner only  
**Purpose**: Revoke operator privileges from an address  
**Emits**: `OperatorRemoved`  
**Gas Cost**: Approximately 30,000

```solidity
function removeOperator(address _operator) 
    external 
    onlyOwner
```

</td>
</tr>
</table>

---

### Operational Functions

<table>
<tr>
<td width="50%">

#### increment

**Access**: Operators only  
**Purpose**: Increase counter by 1  
**Emits**: `CounterUpdated`  
**Gas Cost**: Approximately 48,000

```solidity
function increment() 
    external 
    onlyOperator
```

</td>
<td width="50%">

#### decrement

**Access**: Operators only  
**Purpose**: Decrease counter by 1  
**Requires**: Counter must be greater than 0  
**Emits**: `CounterUpdated`  
**Gas Cost**: Approximately 51,000

```solidity
function decrement() 
    external 
    onlyOperator
```

</td>
</tr>
</table>

---

## How It Works

### Deployment Process
1. Contract is deployed with the deployer becoming the owner
2. Owner automatically receives operator status
3. Counter starts at 0

### Managing Operators
1. Owner calls `addOperator(address)` to give someone operator privileges
2. The new operator can now modify the counter
3. Owner calls `removeOperator(address)` to take away privileges
4. Each action emits an event for tracking

### Using the Counter
1. An authorized operator calls `increment()` or `decrement()`
2. The counter value updates accordingly
3. A `CounterUpdated` event is emitted with the operator's address and new value
4. Anyone can read the current counter value since it's a public variable

---

## Security Features

### Built-In Protections

| Protection | How It Works | Status |
|------------|---------------|--------|
| **Access Control** | Uses `onlyOwner` and `onlyOperator` modifiers | Active |
| **Underflow Prevention** | Checks that counter is above 0 before decrementing | Active |
| **Overflow Protection** | Solidity 0.8.20 has automatic overflow checks | Active |
| **Reentrancy Guard** | No external calls made by the contract | Not Needed |

### Important Considerations

<details>
<summary><b>Centralized Control</b></summary>

The owner has complete control over who can be an operator. For production use, consider:
- Using a multi-signature wallet as the owner
- Adding time delays for critical operations
- Implementing an emergency pause mechanism
- Integrating with a governance system

</details>

<details>
<summary><b>No Ownership Transfer</b></summary>

This version does not allow transferring ownership. For production, you should add:
- A two-step ownership transfer (propose then accept)
- An option to renounce ownership
- Clear procedures for governance changes

</details>

<details>
<summary><b>Permanent Counter State</b></summary>

The counter cannot be reset to a specific value:
- No way for admin to manually set the counter
- No maximum limit on the counter value
- Consider adding a reset function if needed for your use case

</details>

---

## Gas Optimization

### Current Optimizations

**O(1) Operator Lookup** - Using a mapping provides instant access to check operator status  
**Minimal Storage** - Only three state variables to keep costs low  
**Event-Based History** - Events store history off-chain while keeping on-chain proof  
**No Loops** - All operations complete in constant time  

### Gas Cost Breakdown

| Operation | Approximate Gas | Notes |
|-----------|----------------|-------|
| Deployment | ~350,000 | One-time cost when deploying |
| `addOperator()` | ~45,000 | Cost when adding new operator |
| `removeOperator()` | ~30,000 | Cost when removing operator |
| `increment()` | ~48,000 | Includes storage update and event |
| `decrement()` | ~51,000 | Slightly higher due to require check |
| Read operations | ~2,100 | Free when called off-chain |

---

## Possible Improvements

<table>
<tr>
<td width="50%">

**Functionality Enhancements**
- Add ability to transfer ownership
- Add function to reset counter (admin only)
- Allow setting counter to a specific value
- Set maximum and minimum counter bounds
- Add expiration dates for operator privileges
- Allow adding/removing multiple operators at once

</td>
<td width="50%">

**Advanced Features**
- Add emergency pause functionality
- Support multiple types of roles with different permissions
- Track historical counter values with snapshots
- Manage multiple independent counters
- Integrate with governance token voting
- Make contract upgradeable using proxy pattern

</td>
</tr>
</table>

---

## Testing Checklist

### Basic Functionality
- [ ] Contract deploys with correct owner address
- [ ] Owner is automatically set as an operator
- [ ] Counter starts at zero
- [ ] Increment increases counter by 1
- [ ] Decrement decreases counter by 1
- [ ] Cannot decrement when counter is zero

### Access Control
- [ ] Non-owner cannot add operators
- [ ] Non-owner cannot remove operators  
- [ ] Non-operator cannot increment counter
- [ ] Non-operator cannot decrement counter
- [ ] Removed operators immediately lose access
- [ ] Can add the same operator multiple times without error

### Event Testing
- [ ] `OperatorAdded` emits with correct address
- [ ] `OperatorRemoved` emits with correct address
- [ ] `CounterUpdated` emits with operator address and new value
- [ ] Events have proper indexed parameters

### Edge Cases
- [ ] Adding zero address as operator
- [ ] Removing an operator that doesn't exist
- [ ] Multiple operators working at the same time
- [ ] Owner removes their own operator status
- [ ] Counter approaching maximum uint256 value

---

## Real-World Use Cases

### Enterprise Applications
- **Access-controlled registries** where multiple departments need write permissions
- **Collaborative scoreboards** for tracking business metrics across teams
- **Transaction counters** for audit trails in multi-signature systems

### Gaming and DAOs
- **DAO proposal counters** where trusted members can create proposals
- **Game score management** where verified game servers update player scores
- **Achievement tracking** with authorized event handlers

### Infrastructure
- **Rate limiting** for API gateway smart contracts
- **Resource usage tracking** in decentralized systems
- **Version numbering** for protocol upgrades and releases

---

## License

This project is licensed under the MIT License

```
SPDX-License-Identifier: MIT
```

Permission is granted to use, copy, modify, and distribute this software freely.

---

<div align="center">

## Contributing

Contributions, issues, and feature requests are welcome.

Check the issues page or submit a pull request.

---

## Connect With Me

[![LinkedIn](https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/sidheshwar-yengudle-113882241/)
[![Twitter](https://img.shields.io/badge/Twitter-1DA1F2?style=for-the-badge&logo=twitter&logoColor=white)](https://x.com/SYangudale)
[![GitHub](https://img.shields.io/badge/GitHub-100000?style=for-the-badge&logo=github&logoColor=white)](https://github.com/Siddheshwar-cloud)

**Sidheshwar Yengudle** - Blockchain Developer

---

**Built with Solidity 0.8.20 • Following Ethereum Best Practices**

---

*Simple. Secure. Scalable.*

</div>

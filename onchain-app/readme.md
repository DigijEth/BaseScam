# **BaseScam Registry Smart Contract**

A smart contract designed to create a community-driven registry for reporting and assessing tokens on Basechain (a Layer 2 Ethereum network). Users can report suspicious tokens, vote on their safety, and query the status of tokens.

---

## **Table of Contents**

- [Introduction](#introduction)
- [Features](#features)
- [Options for Identity Verification](#options-for-identity-verification)
  - [Option 1: No Identity Verification](#option-1-no-identity-verification)
  - [Option 2: BrightID Integration](#option-2-brightid-integration)
  - [Option 3: Proof-of-Humanity Integration](#option-3-proof-of-humanity-integration)
- [Contract Implementation](#contract-implementation)
  - [Common Contract Features](#common-contract-features)
  - [Option-Specific Implementations](#option-specific-implementations)
- [Deployment Instructions](#deployment-instructions)
- [Interacting with the Contract](#interacting-with-the-contract)
- [Security Considerations](#security-considerations)
- [Next Steps](#next-steps)
- [License](#license)

---

## **Introduction**

The basescam registry smart contract allows users to:

- **Report Suspicious Tokens**: Users can report tokens they believe are fraudulent or risky.
- **Vote on Tokens**: Users can cast positive or negative votes on tokens.
- **Query Token Status**: Anyone can check if a token has been reported, its vote counts, and whether it's considered risky or safe.
- **Admin Functions**: Admins can verify tokens, clear reports, and adjust thresholds.

---

## **Features**

- **Community-Driven Reporting and Voting**: Encourages user participation in assessing token risks.
- **Threshold-Based Risk Assessment**: Tokens are marked risky or safe based on the number of reports and votes.
- **Identity Verification Options**: Supports different levels of identity verification to prevent Sybil attacks.

---

## **Options for Identity Verification**

To enhance the integrity of the reporting and voting system, the contract offers three options for identity verification:

### **Option 1: No Identity Verification**

- **Description**: Anyone can report or vote on tokens without any identity verification.
- **Pros**:
  - Maximum accessibility; low barrier to entry.
- **Cons**:
  - Vulnerable to Sybil attacks (users creating multiple accounts to manipulate votes).

### **Option 2: BrightID Integration**

- **Description**: Users must verify their identity using BrightID, a decentralized identity verification system.
- **Pros**:
  - Mitigates Sybil attacks by ensuring each user is unique.
- **Cons**:
  - Requires users to go through BrightID verification.
  - Additional infrastructure needed (BrightID Verifier contract, subgraph).

### **Option 3: Proof-of-Humanity Integration**

- **Description**: Users must be registered with Proof-of-Humanity, an on-chain registry of unique humans.
- **Pros**:
  - Strong identity verification; reduces Sybil attacks.
- **Cons**:
  - Users must complete the Proof-of-Humanity registration process.
  - May reveal personal information linked to their address.

---

## **Contract Implementation**

### **Common Contract Features**

All options share common functionalities:

- **Data Structures**:
  - `Report` struct to hold report details.
  - Mappings for token reports, votes, and verification statuses.

- **Functions**:
  - `reportToken()`: Report a token as suspicious.
  - `voteOnToken()`: Cast a positive or negative vote on a token.
  - `getReportCount()`: Get the number of reports for a token.
  - `getReports()`: Retrieve all reports for a token.
  - `isTokenRisky()`: Check if a token is considered risky.
  - `isTokenSafe()`: Check if a token is considered safe.
  - `verifyToken()`: Admin function to verify a token.
  - `clearReports()`: Admin function to clear reports and votes.
  - `updateThresholds()`: Admin function to adjust thresholds.

- **Events**:
  - Emitted for reporting, voting, verifying tokens, and threshold updates.

- **Admin Control**:
  - Admin address with restricted functions.
  - Ability to transfer admin rights.

### **Option-Specific Implementations**

#### **Option 1: No Identity Verification**

- **Contract Name**: `TokenReportRegistry`
- **Code Snippet**:

  ```solidity
  // SPDX-License-Identifier: MIT
  pragma solidity ^0.8.0;

  contract TokenReportRegistry {
      // Common contract code without identity verification modifiers
      // ...

      // Users can report or vote without restrictions
      // ...

      // No additional modifiers or integrations
      // ...
  }
  ```

- **Usage**:
  - Anyone can call `reportToken()` and `voteOnToken()` without any verification.

#### **Option 2: BrightID Integration**

- **Contract Name**: `TokenReportRegistryBrightID`
- **Code Snippet**:

  ```solidity
  // SPDX-License-Identifier: MIT
  pragma solidity ^0.8.0;

  interface IBrightIDVerifier {
      function isVerified(
          address addr,
          string calldata context,
          uint256 timestamp
      ) external view returns (bool);
  }

  contract TokenReportRegistryBrightID {
      IBrightIDVerifier public brightIDVerifier;
      string public brightIDContext;
      uint256 public brightIDVerificationTimestamp;

      // Common contract variables and mappings
      // ...

      // Constructor
      constructor(
          address _brightIDVerifierAddress,
          string memory _brightIDContext,
          uint256 _riskThreshold,
          uint256 _safeThreshold
      ) {
          admin = msg.sender;
          brightIDVerifier = IBrightIDVerifier(_brightIDVerifierAddress);
          brightIDContext = _brightIDContext;
          brightIDVerificationTimestamp = block.timestamp;
          riskThreshold = _riskThreshold;
          safeThreshold = _safeThreshold;
      }

      // Modifier to check if sender is a verified BrightID user
      modifier onlyVerifiedUser() {
          require(
              brightIDVerifier.isVerified(
                  msg.sender,
                  brightIDContext,
                  brightIDVerificationTimestamp
              ),
              "You are not verified with BrightID for this application"
          );
          _;
      }

      // Apply the modifier to report and vote functions
      function reportToken(address _tokenAddress, string calldata _reason) external onlyVerifiedUser {
          // Function code
      }

      function voteOnToken(address _tokenAddress, bool _isPositive) external onlyVerifiedUser {
          // Function code
      }

      // Rest of the contract code
      // ...
  }
  ```

- **Usage**:
  - Users must be verified with BrightID under the specified context to report or vote.
  - Requires deploying the BrightID Verifier contract and setting up a subgraph.

#### **Option 3: Proof-of-Humanity Integration**

- **Contract Name**: `TokenReportRegistryPoH`
- **Code Snippet**:

  ```solidity
  // SPDX-License-Identifier: MIT
  pragma solidity ^0.8.0;

  interface IProofOfHumanity {
      function isRegistered(address _submissionID) external view returns (bool);
  }

  contract TokenReportRegistryPoH {
      IProofOfHumanity public proofOfHumanity;

      // Common contract variables and mappings
      // ...

      // Constructor
      constructor(
          address _proofOfHumanityAddress,
          uint256 _riskThreshold,
          uint256 _safeThreshold
      ) {
          admin = msg.sender;
          proofOfHumanity = IProofOfHumanity(_proofOfHumanityAddress);
          riskThreshold = _riskThreshold;
          safeThreshold = _safeThreshold;
      }

      // Modifier to check if sender is registered with Proof-of-Humanity
      modifier onlyHuman() {
          require(proofOfHumanity.isRegistered(msg.sender), "You are not registered with Proof-of-Humanity");
          _;
      }

      // Apply the modifier to report and vote functions
      function reportToken(address _tokenAddress, string calldata _reason) external onlyHuman {
          // Function code
      }

      function voteOnToken(address _tokenAddress, bool _isPositive) external onlyHuman {
          // Function code
      }

      // Rest of the contract code
      // ...
  }
  ```

- **Usage**:
  - Users must be registered with Proof-of-Humanity to report or vote.
  - No additional infrastructure is required beyond the Proof-of-Humanity contract.

---

## **Deployment Instructions**

### **Common Steps**

1. **Prerequisites**:

   - Solidity compiler (e.g., via Remix, Hardhat).
   - MetaMask configured for Basechain.
   - Sufficient funds for gas fees.

2. **Compile the Contract**:

   - Use the appropriate Solidity compiler version (e.g., `0.8.x`).

3. **Deploy the Contract**:

   - Deploy the contract to Basechain using Remix or Hardhat.
   - Provide the required constructor parameters based on the chosen option.

### **Option-Specific Deployment**

#### **Option 1: No Identity Verification**

- **Constructor Parameters**:

  ```solidity
  constructor(uint256 _riskThreshold, uint256 _safeThreshold)
  ```

- **Example Deployment**:

  - `riskThreshold = 5`
  - `safeThreshold = 10`

#### **Option 2: BrightID Integration**

- **Prerequisites**:

  - Deploy the BrightID Verifier contract on Basechain.
  - Obtain your application's BrightID context string.

- **Constructor Parameters**:

  ```solidity
  constructor(
      address _brightIDVerifierAddress,
      string memory _brightIDContext,
      uint256 _riskThreshold,
      uint256 _safeThreshold
  )
  ```

- **Example Deployment**:

  - `_brightIDVerifierAddress`: Address of the deployed BrightID Verifier contract.
  - `_brightIDContext`: Your BrightID application context string.
  - `riskThreshold = 5`
  - `safeThreshold = 10`

#### **Option 3: Proof-of-Humanity Integration**

- **Constructor Parameters**:

  ```solidity
  constructor(
      address _proofOfHumanityAddress,
      uint256 _riskThreshold,
      uint256 _safeThreshold
  )
  ```

- **Example Deployment**:

  - `_proofOfHumanityAddress`: Address of the Proof-of-Humanity contract.
  - `riskThreshold = 5`
  - `safeThreshold = 10`

---

## **Interacting with the Contract**

### **Reporting a Token**

```solidity
function reportToken(address _tokenAddress, string calldata _reason) external
```

- **Parameters**:
  - `_tokenAddress`: The address of the token contract.
  - `_reason`: A description of why the token is being reported.

- **Requirements**:
  - Depending on the option, the sender may need to pass the identity verification check.

### **Voting on a Token**

```solidity
function voteOnToken(address _tokenAddress, bool _isPositive) external
```

- **Parameters**:
  - `_tokenAddress`: The address of the token contract.
  - `_isPositive`: `true` for a positive vote (safe), `false` for a negative vote (risky).

- **Requirements**:
  - Depending on the option, the sender may need to pass the identity verification check.

### **Querying Token Status**

- **Get Report Count**:

  ```solidity
  function getReportCount(address _tokenAddress) external view returns (uint256)
  ```

- **Get Reports**:

  ```solidity
  function getReports(address _tokenAddress) external view returns (Report[] memory)
  ```

- **Check if Token is Risky**:

  ```solidity
  function isTokenRisky(address _tokenAddress) public view returns (bool)
  ```

- **Check if Token is Safe**:

  ```solidity
  function isTokenSafe(address _tokenAddress) public view returns (bool)
  ```

### **Admin Functions**

- **Verify a Token**:

  ```solidity
  function verifyToken(address _tokenAddress) external onlyAdmin
  ```

- **Clear Reports and Votes**:

  ```solidity
  function clearReports(address _tokenAddress) external onlyAdmin
  ```

- **Update Thresholds**:

  ```solidity
  function updateThresholds(uint256 _riskThreshold, uint256 _safeThreshold) external onlyAdmin
  ```

- **Transfer Admin Rights**:

  ```solidity
  function transferAdmin(address _newAdmin) external onlyAdmin
  ```

---

## **Security Considerations**

- **Sybil Attacks**:

  - **Option 1** is vulnerable to Sybil attacks since no identity verification is required.
  - **Options 2 and 3** mitigate Sybil attacks by ensuring users are unique through identity verification.

- **Identity Verification Dependencies**:

  - **BrightID Integration** relies on external infrastructure (verifier contract, subgraph).
  - **Proof-of-Humanity Integration** depends on the availability and reliability of the PoH contract.

- **Admin Trust**:

  - The admin has significant control over the contract.
  - Consider using a multisignature wallet or decentralized governance for admin functions.

- **Gas Costs**:

  - Be mindful of gas costs when interacting with the contract.
  - Identity verification checks may add to gas consumption.

- **Privacy Concerns**:

  - **Proof-of-Humanity** may link users' addresses to personal information.
  - **BrightID** aims to preserve user anonymity.

---

## **Next Steps**

- **Deploy the Chosen Contract**:

  - Decide on the level of identity verification appropriate for your use case.
  - Follow the deployment instructions for that option.

- **Develop a Front-End Interface**:

  - Create a user-friendly interface for interacting with the contract.
  - Provide guidance for users on any required identity verification steps.

- **Set Up Off-Chain Monitoring**:

  - Use event logs to monitor contract activity.
  - Integrate with services like The Graph for indexing and querying data.

- **Engage with the Community**:

  - Encourage user participation.
  - Gather feedback to improve the system.

- **Consider Enhancements**:

  - Implement reputation systems.
  - Introduce incentivization mechanisms.
  - Explore decentralized governance models.

---

## **Contact**

For questions or support, please open an issue on the GitHub repository or contact the maintainer.

---

**Note**: Ensure you thoroughly test the smart contract and understand the implications of each identity verification option before deploying on the mainnet. Always consider consulting with a smart contract security expert.

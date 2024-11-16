To support our efforts, donate to digij.eth or digij.base.eth

If you would like to join our team, please let us know!

---

# **BaseScamRegistry**

**BaseScamRegistry** is an on-chain registry designed to report, evaluate, and manage smart contracts, enabling users to flag scams and share reviews. This platform fosters transparency in blockchain ecosystems, combining user-driven reporting with dynamic risk analysis and incentivized community engagement.

---

## **Table of Contents**
1. [Overview](#overview)
2. [Features](#features)
3. [Technical Details](#technical-details)
4. [Smart Contract Architecture](#smart-contract-architecture)
5. [Usage Guide](#usage-guide)
6. [Installation and Deployment](#installation-and-deployment)
7. [Future Enhancements](#future-enhancements)
8. [License](#license)

---

## **Overview**

The **BaseScamRegistry** platform aims to:
- Allow users to report suspicious smart contracts.
- Provide a decentralized review system for token and project evaluations.
- Incentivize users with token-based engagement.
- Offer token owners tools for transparency, such as audit certificates and project details.
- Dynamically escalate reports based on community votes and activity.

---

## **Features**

### **Core Features**
1. **Reporting and Voting**:
   - Report tokens by burning `BSCAM` tokens.
   - Vote on reports to escalate suspicious tokens for review.

2. **Token Details**:
   - Verified token owners can add:
     - Contact information.
     - Links to Web3 pages.
     - Audit certificates (e.g., IPFS hash).
     - Contract type (e.g., ERC-20, ERC-721).

3. **Reviews**:
   - Submit and vote on token reviews.
   - Upvoted incentivized reviews become visible to the community.

4. **Dynamic Escalation**:
   - Adjusts report escalation thresholds based on the number of active reports.

5. **Premium Access**:
   - Unlock premium features (e.g., early access to reports) for $9.99 in USDC.

6. **Cross-Chain Compatibility**:
   - Supports tokens and projects across Basechain and other blockchains.

7. **Incentivized Engagement**:
   - Users earn rewards for submitting high-quality reviews and participating in escalated reports.

8. **Insurance Pool**:
   - Funded by burned `BSCAM` tokens and direct USDC contributions.
   - Reimburses victims of scams upon admin approval.

---

## **Technical Details**

### **Token Integration**
1. **BSCAM Token**:
   - Required to:
     - Submit reports.
     - Vote on reports and reviews.
     - Add incentivized reviews.
   - Can be purchased in batches of 5,000 for $5.99 in USDC.

2. **USDC**:
   - Used for:
     - Purchasing `BSCAM` tokens.
     - Paying for premium subscriptions.

### **Dynamic Escalation Thresholds**
- Thresholds adjust based on active reports:
  - 0–50 reports: 10 votes.
  - 51–100 reports: 15 votes.
  - 100+ reports: 20 votes.

---

## **Smart Contract Architecture**

### **Core Components**
1. **Reports**:
   - Tracks reports submitted by users.
   - Includes:
     - Reporter address.
     - Reason for the report.
     - Timestamp.
     - Escalation status.

2. **Token Details**:
   - Allows token owners to add:
     - Contact information.
     - Web3 links.
     - Audit certificates.
     - Contract type.

3. **Reviews**:
   - Allows users to submit and vote on reviews.
   - Stores:
     - Reviewer address.
     - Review content.
     - Upvotes and downvotes.

4. **Insurance Pool**:
   - Funded by:
     - Burned `BSCAM` tokens.
     - Direct USDC contributions.

5. **Premium Subscriptions**:
   - Users can pay $9.99 in USDC for 30 days of premium features.

### **Data Structures**
- **Report**:
  ```solidity
  struct Report {
      address reporter;
      string reason;
      uint256 timestamp;
      string ownerResponse;
      bool escalated;
      uint256 votes;
  }
  ```

- **TokenDetails**:
  ```solidity
  struct TokenDetails {
      string contactInfo;
      string web3Page;
      string auditCertificate;
      string contractType;
  }
  ```

- **Review**:
  ```solidity
  struct Review {
      address reviewer;
      string content;
      uint256 upvotes;
      uint256 downvotes;
  }
  ```

---

## **Usage Guide**

### **For Users**
1. **Submit a Report**:
   - Use `submitReport(address tokenAddress, string calldata reason)` to flag a suspicious token.
   - Requires `1 BSCAM` token.

2. **Vote on a Report**:
   - Use `voteOnReport(address tokenAddress, uint256 reportIndex)` to escalate a report.
   - Requires `1 BSCAM` token per vote.

3. **Submit a Review**:
   - Use `submitReview(address tokenAddress, string calldata content)` to review a token.
   - Requires `2 BSCAM` tokens.

4. **Purchase Premium**:
   - Use `purchasePremium()` to unlock premium features for $9.99 in USDC.

5. **Purchase BSCAM Tokens**:
   - Use `purchaseTokens(uint256 amount)` to buy `BSCAM` tokens in batches of 5,000 for $5.99 in USDC.

---

### **For Token Owners**
1. **Add Token Details**:
   - Use `updateTokenDetails(address tokenAddress, ...)` to:
     - Add contact information.
     - Link an audit certificate.
     - Specify contract type (e.g., ERC-20, ERC-721).

---

## **Installation and Deployment**

### **Prerequisites**
- **Solidity**: Version 0.8.x.
- **Node.js**: For Hardhat or Truffle setup.
- **Basechain Wallet**: For deployment and interaction.

### **Deployment Steps**
1. Clone the repository:
   ```bash
   git clone https://github.com/your-repo/BaseScamRegistry.git
   cd BaseScamRegistry
   ```

2. Install dependencies:
   ```bash
   npm install
   ```

3. Compile the contracts:
   ```bash
   npx hardhat compile
   ```

4. Deploy to Basechain:
   ```bash
   npx hardhat run scripts/deploy.js --network basechain
   ```

---

## **Future Enhancements**

1. **AI-Powered Scam Detection**:
   - Integrate machine learning to flag suspicious tokens automatically.

2. **Global Blacklist Sharing**:
   - Develop an API for third-party platforms to access blacklisted tokens.

3. **Cross-Chain Expansion**:
   - Add support for Ethereum, Binance Smart Chain, and Polygon.

4. **Anonymous Reporting**:
   - Use zero-knowledge proofs to protect whistleblower identities.

5. **Revenue Redistribution**:
   - Share platform earnings with active contributors.

---

## **License**

This project is licensed under the **GNU General Public License v3.0 (GPL-3.0)**. See the [LICENSE](LICENSE) file for details.

---

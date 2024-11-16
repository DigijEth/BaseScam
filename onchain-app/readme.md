
# BaseScamRegistry

**BaseScamRegistry** is a decentralized registry for tracking, reporting, and evaluating blockchain projects, tokens, and smart contracts on Basechain. This contract allows users to report suspicious tokens, submit reviews, verify ownership, and access additional features through the use of `BSCAM` tokens and USDC.

## Features

### Core Enhancements
1. **Audit and Certification**:
   - Token owners can upload audit certificates (e.g., a document link or hash) to demonstrate project security and compliance.

2. **Scam Detection**:
   - Dynamic thresholds for escalating suspicious reports.
   - Reports marked as "escalated" can be prioritized for review.

3. **Cross-Chain Compatibility**:
   - Supports tokens and projects from Basechain and other blockchains.
   - Allows classification of contracts into types like ERC-20, ERC-721, etc.

4. **Dynamic Escalation Rules**:
   - Automatically adjusts the escalation threshold based on the number of active reports to ensure scalability.

---

### User Incentives and Engagement
1. **Token Gating for Features**:
   - Users must hold or burn `BSCAM` tokens to perform certain actions, such as submitting reports or reviews.

2. **Incentivized Reviews**:
   - Community members can submit detailed reviews of projects.
   - Reviews can be upvoted or downvoted by others.

3. **Subscription-Based Premium Features**:
   - Users can pay $9.99 in USDC to unlock premium features, including:
     - Early access to flagged reports.
     - Advanced filtering and analytics.

---

## Contract Structure

### Main Components
1. **Reports**:
   - Users can report suspicious tokens by burning `BSCAM` tokens.
   - Reports include:
     - Reporter address
     - Reason for the report
     - Timestamp
     - Owner response (optional)
     - Escalation status

2. **Token Details**:
   - Verified token owners can provide:
     - Contact information
     - A link to their Web3 page
     - An audit certificate (e.g., link or IPFS hash)
     - Contract type (e.g., Token, NFT)

3. **Reviews**:
   - Users can submit reviews for tokens and vote on existing reviews.
   - Reviews include:
     - Reviewer address
     - Review content
     - Upvote and downvote counts

4. **Dynamic Escalation**:
   - Automatically adjusts the escalation threshold based on the number of active reports:
     - 0–50 active reports: Escalation threshold = 10 votes.
     - 51–100 active reports: Escalation threshold = 15 votes.
     - 100+ active reports: Escalation threshold = 20 votes.

5. **Premium Access**:
   - Users can purchase 30 days of premium access by paying $9.99 in USDC.
   - Premium features include advanced analytics and early access to flagged reports.

---

## Token Integration

1. **BSCAM Token**:
   - Users must hold or burn `BSCAM` tokens to:
     - Submit reports
     - Add reviews
     - Vote on reviews
   - `BSCAM` tokens can be purchased in batches of 5,000 for $5.99 in USDC.

2. **USDC**:
   - USDC is used for purchasing:
     - `BSCAM` tokens
     - Premium subscriptions

---

## Smart Contract Functions

### Core Functions
- **`reportToken(address _tokenAddress, string calldata _reason)`**:
  - Submit a report for a suspicious token by burning `BSCAM` tokens.
- **`verifyTokenOwnership(address _tokenAddress, string calldata _contactInfo, string calldata _web3Page, string calldata _contractType, string calldata _auditCertificate)`**:
  - Token owners can verify their ownership and provide audit details.
- **`escalateReport(address _tokenAddress, uint256 _reportIndex)`**:
  - Mark a report as "escalated" if it meets specific criteria.

### Review Functions
- **`addReview(address _tokenAddress, string calldata _content)`**:
  - Submit a review for a token by burning `BSCAM` tokens.
- **`voteReview(address _tokenAddress, uint256 _reviewIndex, bool upvote)`**:
  - Upvote or downvote a submitted review.

### Premium Features
- **`purchaseSubscription()`**:
  - Pay $9.99 in USDC to unlock premium access for 30 days.
- **`hasPremiumAccess(address _user)`**:
  - Check if a user has an active premium subscription.

### Utility Functions
- **`updateEscalationThreshold()`**:
  - Dynamically adjust the escalation threshold based on active reports.
- **`hasPremiumAccess(address _user)`**:
  - Check if a user has an active premium subscription.

---

## Deployment Instructions

### Prerequisites
- Deploy the **BSCAMToken** contract first.
- Deploy the **BaseScamRegistry** contract, passing the deployed `BSCAMToken` and Basechain `USDC` contract addresses to the constructor.

### Environment Setup
1. Configure your wallet and deployment environment for Basechain.
2. Use a development framework like **Hardhat** or **Truffle** for contract compilation and deployment.

---

## Example Usage

### 1. Reporting a Token
- Burn `BSCAM` tokens and submit a report for a suspicious token:
  ```solidity
  reportToken("0xTokenAddress", "Suspicious behavior detected.");
  ```

### 2. Verifying Token Ownership
- Provide contact information and an audit certificate:
  ```solidity
  verifyTokenOwnership(
      "0xTokenAddress",
      "contact@tokenproject.com",
      "https://web3page.tokenproject.com",
      "Token",
      "https://audit.certificates.com/tokenproject"
  );
  ```

### 3. Adding a Review
- Submit a review by burning `BSCAM` tokens:
  ```solidity
  addReview("0xTokenAddress", "Great project with a solid team.");
  ```

### 4. Purchasing Premium Access
- Unlock premium features by paying $9.99 in USDC:
  ```solidity
  purchaseSubscription();
  ```

---

## Future Improvements
- **Crowdfunding for Recovery**: Allow users to fund recovery efforts for escalated cases.
- **Integration with Machine Learning**: Use AI-based scam detection for automated risk assessments.
- **Advanced Analytics**: Include transaction frequency, holder distribution, and price trends for registered tokens.

---

## License

This project is licensed under the **GNU General Public License v3.0 (GNU-3)**. See the [LICENSE](LICENSE) file for details.

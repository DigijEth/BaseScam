// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "./BSCAMToken.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface IERC20Metadata is IERC20 {
    function owner() external view returns (address);
}

contract BaseScamRegistry {
    // Struct to hold report details
    struct Report {
        address reporter;
        string reason;
        uint256 timestamp;
        uint256 votes;
        string ownerResponse;
        bool escalated;
        uint256 riskScore; // Automated risk score
    }

    // Struct to hold token owner details
    struct TokenDetails {
        bool isVerified;
        string contactInfo;
        string web3Page;
        string contractType;
        int256 reputation; // Reputation score for tokens
        string auditCertificate;
        uint256 fundsRaised; // Funds tracked for the project
        uint256 milestoneProgress; // Project milestone progress (0-100%)
    }

    // Struct for reviews
    struct Review {
        address reviewer;
        string content;
        uint256 upvotes;
        uint256 downvotes;
        bool visible;
    }

    // Insurance Pool
    uint256 public insurancePool;

    // Admin and tokens
    address public admin;
    BSCAMToken public bscamToken;
    IERC20 public usdc;

    // Reputation and voting
    mapping(address => uint256) public reputation;
    mapping(address => uint256) public votesInPeriod;

    // Escalation and risk scoring
    uint256 public escalationThreshold = 5;
    mapping(address => uint256) public riskScores;

    // Flagged addresses
    mapping(address => bool) public flaggedAddresses;

    // Referral tracking
    mapping(address => address) public referrals;
    uint256 public referralReward = 50 * (10 ** 18); // 50 BSCAM tokens

    // Events
    event AdminAction(address indexed admin, string action, uint256 timestamp);
    event TokenVoted(address indexed voter, address indexed token, uint256 amount);
    event FundsAddedToInsurancePool(address indexed from, uint256 amount);
    event FundsClaimedFromInsurancePool(address indexed to, uint256 amount);
    event ReferralRewarded(address indexed referrer, address indexed referee, uint256 amount);
    event NFTPremiumAccessMinted(address indexed user, string nftURI);

    constructor(BSCAMToken _bscamToken, IERC20 _usdc) {
        admin = msg.sender;
        bscamToken = _bscamToken;
        usdc = _usdc;
    }

    // ==============================
    // Insurance Pool and Contributions
    // ==============================

    function contributeToInsurancePool(uint256 amount) external {
        require(usdc.transferFrom(msg.sender, address(this), amount), "USDC transfer failed");
        insurancePool += amount;
        emit FundsAddedToInsurancePool(msg.sender, amount);
    }

    function claimFromInsurancePool(address to, uint256 amount) external onlyAdmin {
        require(insurancePool >= amount, "Insufficient funds in pool");
        insurancePool -= amount;
        require(usdc.transfer(to, amount), "USDC transfer failed");
        emit FundsClaimedFromInsurancePool(to, amount);
    }

    function dynamicContribution(uint256 fee) internal {
        uint256 contribution = (fee * 10) / 100; // 10% contribution to the insurance pool
        insurancePool += contribution;
        emit FundsAddedToInsurancePool(msg.sender, contribution);
    }

    // ==============================
    // Voting System
    // ==============================

    function weightedVote(address _tokenAddress, uint256 reportIndex, bool voteFor) external {
        require(bscamToken.balanceOf(msg.sender) >= 1 * (10 ** 18), "Insufficient BSCAM tokens");
        require(reputation[msg.sender] >= 0, "Reputation too low to vote");

        uint256 weight = reputation[msg.sender] > 10 ? 2 : 1; // Weight votes by reputation
        votesInPeriod[msg.sender] += weight;

        // Transfer tokens to the insurance pool
        require(bscamToken.transferFrom(msg.sender, address(this), 1 * (10 ** 18)), "Token transfer failed");
        insurancePool += 1 * (10 ** 18);

        emit TokenVoted(msg.sender, _tokenAddress, 1 * (10 ** 18));
    }

    // ==============================
    // Referrals and Rewards
    // ==============================

    function setReferral(address referrer) external {
        require(referrals[msg.sender] == address(0), "Referral already set");
        require(referrer != msg.sender, "Cannot refer yourself");
        referrals[msg.sender] = referrer;
    }

    function rewardReferral(address referee) external onlyAdmin {
        address referrer = referrals[referee];
        require(referrer != address(0), "No referrer for this address");

        // Reward the referrer
        require(bscamToken.mint(referrer, referralReward), "Minting failed");
        emit ReferralRewarded(referrer, referee, referralReward);
    }

    // ==============================
    // Premium Access via NFTs
    // ==============================

    function mintPremiumNFT(address user, string calldata nftURI) external onlyAdmin {
        // Placeholder logic: Integrate with an NFT minting contract
        emit NFTPremiumAccessMinted(user, nftURI);
    }

    // ==============================
    // Historical Data Dashboard
    // ==============================

    function getTokenMetrics(address _tokenAddress) external view returns (uint256, uint256, uint256) {
        return (
            tokenDetails[_tokenAddress].fundsRaised,
            tokenDetails[_tokenAddress].milestoneProgress,
            riskScores[_tokenAddress]
        );
    }

    // ==============================
    // Multisig Admin Controls
    // ==============================

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can perform this action");
        _;
    }

    function addAdmin(address newAdmin) external onlyAdmin {
        admin = newAdmin;
        emit AdminAction(msg.sender, "Add Admin", block.timestamp);
    }
}

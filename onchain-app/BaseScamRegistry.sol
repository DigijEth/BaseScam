// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.20;

import "./BSCAMToken.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol"; // Import OpenZeppelin's IERC20Metadata

contract BaseScamRegistry {
    // Struct to hold report details
    struct Report {
        address reporter;
        string reason;
        uint256 timestamp;
        string ownerResponse;
        bool escalated;
        uint256 votes;
    }

    // Struct for user profiles
    struct UserProfile {
        string displayName;
        string bio;
        string web3Page;
        uint8 tier; // 0 = Free, 1 = Paid, 2 = Elite
        int256 reputation; // Reputation score
    }

    // Struct for token details
    struct TokenDetails {
        string contactInfo;
        string web3Page;
        string auditCertificate;
        string contractType;
        bool isVerified;
    }

    // Struct for reviews
    struct Review {
        address reviewer;
        string content;
        uint256 upvotes;
        uint256 downvotes;
        bool visible;
        bool incentivized;
    }

    // Struct for insurance claims
    struct InsuranceClaim {
        address claimant;
        uint256 amount;
        string reason;
        uint256 timestamp;
        bool approved;
        bool processed;
    }

    // Mappings
    mapping(address => Report[]) public tokenReports;
    mapping(address => UserProfile) public userProfiles;
    mapping(address => TokenDetails) public tokenDetails;
    mapping(address => Review[]) public tokenReviews;
    mapping(uint256 => InsuranceClaim) public insuranceClaims;

    // Faucet claims
    mapping(address => uint256) public lastFaucetClaim;

    // Daily vote limits
    mapping(address => mapping(address => uint256)) public dailyVotes;

    // Admin and pool details
    address public admin;
    uint256 public insurancePool;
    uint256 public totalReports;
    uint256 public totalTokensBurned;

    // Configurations
    uint256 public constant FAUCET_AMOUNT = 500 * (10 ** 18);
    uint256 public constant REVIEW_UPVOTE_THRESHOLD = 5;
    uint256 public constant INSURANCE_CLAIM_COST = 10 * (10 ** 18);
    uint256 public constant MAX_VOTES_PER_DAY = 3;
    uint256 public constant MAX_TOKENS_PER_VOTE = 1000 * (10 ** 18);

    // Reputation configuration
    int256 public constant REPORT_REWARD = 10;
    int256 public constant VOTE_REWARD = 5;
    int256 public constant FALSE_REPORT_PENALTY = -20;

    // Insurance claim counter
    uint256 public insuranceClaimCounter;

    // Events
    event ReportSubmitted(address indexed token, address indexed reporter);
    event TokenDetailsUpdated(address indexed token, string contactInfo, string web3Page, string auditCertificate, string contractType);
    event TokenVerified(address indexed token);
    event ReviewSubmitted(address indexed token, address indexed reviewer, string content);
    event ReviewVoted(address indexed token, uint256 reviewIndex, bool upvoted, uint256 totalUpvotes);
    event ReviewVisibilityUpdated(address indexed token, uint256 reviewIndex, bool visible);
    event InsuranceClaimSubmitted(address indexed claimant, uint256 claimId, uint256 amount);
    event InsuranceClaimProcessed(uint256 claimId, bool approved);
    event AnalyticsUpdated(uint256 totalReports, uint256 totalTokensBurned);
    event FaucetClaimed(address indexed user, uint256 amount);

    constructor() {
        admin = msg.sender;
        insuranceClaimCounter = 0;
    }

    // ==============================
    // Reporting
    // ==============================

    function submitReport(address _tokenAddress, string calldata _reason) external {
        require(userProfiles[msg.sender].reputation >= 0, "Insufficient reputation");

        tokenReports[_tokenAddress].push(
            Report({
                reporter: msg.sender,
                reason: _reason,
                timestamp: block.timestamp,
                ownerResponse: "",
                escalated: false,
                votes: 0
            })
        );

        totalReports++;
        totalTokensBurned += 1 * (10 ** 18);

        emit ReportSubmitted(_tokenAddress, msg.sender);
        emit AnalyticsUpdated(totalReports, totalTokensBurned);
    }

    // ==============================
    // Token Details
    // ==============================

    function updateTokenDetails(
        address _tokenAddress,
        string calldata _contactInfo,
        string calldata _web3Page,
        string calldata _auditCertificate,
        string calldata _contractType
    ) external {
        require(msg.sender == IERC20Metadata(_tokenAddress).owner(), "Only token owner can update details");

        tokenDetails[_tokenAddress] = TokenDetails({
            contactInfo: _contactInfo,
            web3Page: _web3Page,
            auditCertificate: _auditCertificate,
            contractType: _contractType,
            isVerified: false
        });

        emit TokenDetailsUpdated(_tokenAddress, _contactInfo, _web3Page, _auditCertificate, _contractType);
    }

    function verifyTokenDetails(address _tokenAddress) external onlyAdmin {
        require(!tokenDetails[_tokenAddress].isVerified, "Token already verified");

        tokenDetails[_tokenAddress].isVerified = true;
        emit TokenVerified(_tokenAddress);
    }

    // ==============================
    // Reviews
    // ==============================

    function submitReview(address _tokenAddress, string calldata _content, bool _incentivized) external {
        tokenReviews[_tokenAddress].push(
            Review({
                reviewer: msg.sender,
                content: _content,
                upvotes: 0,
                downvotes: 0,
                visible: !_incentivized,
                incentivized: _incentivized
            })
        );

        emit ReviewSubmitted(_tokenAddress, msg.sender, _content);
    }

    function voteOnReview(address _tokenAddress, uint256 reviewIndex, bool upvote) external {
        require(reviewIndex < tokenReviews[_tokenAddress].length, "Invalid review index");

        Review storage review = tokenReviews[_tokenAddress][reviewIndex];

        if (upvote) {
            review.upvotes++;
        } else {
            review.downvotes++;
        }

        if (review.incentivized && review.upvotes >= REVIEW_UPVOTE_THRESHOLD && !review.visible) {
            review.visible = true;
            emit ReviewVisibilityUpdated(_tokenAddress, reviewIndex, true);
        }

        emit ReviewVoted(_tokenAddress, reviewIndex, upvote, review.upvotes);
    }

    // ==============================
    // Insurance Pool and Escrow
    // ==============================

    function submitInsuranceClaim(uint256 amount, string calldata reason) external {
        require(amount > 0 && amount <= insurancePool, "Invalid claim amount");

        insuranceClaims[insuranceClaimCounter] = InsuranceClaim({
            claimant: msg.sender,
            amount: amount,
            reason: reason,
            timestamp: block.timestamp,
            approved: false,
            processed: false
        });

        emit InsuranceClaimSubmitted(msg.sender, insuranceClaimCounter, amount);
        insuranceClaimCounter++;
    }

    function processInsuranceClaim(uint256 claimId, bool approve) external onlyAdmin {
        InsuranceClaim storage claim = insuranceClaims[claimId];
        require(!claim.processed, "Claim already processed");

        claim.processed = true;
        claim.approved = approve;

        if (approve) {
            require(insurancePool >= claim.amount, "Insufficient insurance pool");
            insurancePool -= claim.amount;
        }

        emit InsuranceClaimProcessed(claimId, approve);
    }

    // ==============================
    // Faucet
    // ==============================

    function claimFaucet() external {
        require(block.timestamp >= lastFaucetClaim[msg.sender] + 30 days, "Faucet can only be claimed every 30 days");

        lastFaucetClaim[msg.sender] = block.timestamp;

        emit FaucetClaimed(msg.sender, FAUCET_AMOUNT);
    }

    // ==============================
    // Admin Functions
    // ==============================

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can perform this action");
        _;
    }

    function setAdmin(address newAdmin) external onlyAdmin {
        admin = newAdmin;
    }
}

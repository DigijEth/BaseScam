// SPDX-License-Identifier: GNU-3.0
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
    }

    // Struct to hold token owner details
    struct TokenDetails {
        bool isVerified;
        string contactInfo;
        string web3Page;
        string contractType; // Token, NFT, etc.
        int256 reputation; // Token reputation score
        string auditCertificate; // Link or hash of the audit certificate
    }

    // Struct for reviews
    struct Review {
        address reviewer;
        string content;
        uint256 upvotes;
        uint256 downvotes;
    }

    // Mapping from token address to list of reports
    mapping(address => Report[]) public tokenReports;

    // Mapping from token address to token details
    mapping(address => TokenDetails) public tokenDetails;

    // Mapping to store reviews for tokens
    mapping(address => Review[]) public tokenReviews;

    // Mapping for dynamic escalation thresholds
    uint256 public escalationThreshold = 10; // Default value
    uint256 public activeReports = 0; // Active reports count

    // Mapping for subscription-based access
    mapping(address => uint256) public premiumAccessExpiry; // Expiry timestamp for premium access

    // Admin and tokens
    address public admin;
    BSCAMToken public bscamToken;
    IERC20 public usdc;

    // Token pricing
    uint256 public constant COST_PER_BATCH = 599 * (10 ** 6); // $5.99 in USDC (assuming 6 decimals)
    uint256 public constant TOKENS_PER_BATCH = 5000 * (10 ** 18); // 5,000 BSCAM tokens (assuming 18 decimals)
    uint256 public constant SUBSCRIPTION_COST = 999 * (10 ** 6); // $9.99 for premium features

    // Voting cost
    uint256 public constant VOTING_COST = 1 * (10 ** 18); // 1 BSCAM token

    // Events
    event TokenReported(address indexed tokenAddress, address indexed reporter, string reason);
    event TokenVerified(address indexed tokenAddress, string contactInfo, string web3Page, string contractType);
    event AuditCertificateUploaded(address indexed tokenAddress, string certificateLink);
    event SubscriptionPurchased(address indexed user, uint256 expiryTimestamp);
    event ReviewAdded(address indexed tokenAddress, address reviewer, string content);
    event TokenEscalated(address indexed tokenAddress, uint256 reportIndex);

    constructor(BSCAMToken _bscamToken, IERC20 _usdc) {
        admin = msg.sender;
        bscamToken = _bscamToken;
        usdc = _usdc;
    }

    // ==============================
    // Core Enhancements
    // ==============================

    // Report a token
    function reportToken(address _tokenAddress, string calldata _reason) external {
        require(bscamToken.balanceOf(msg.sender) >= VOTING_COST, "Insufficient BSCAM tokens");
        bscamToken.burn(msg.sender, VOTING_COST); // Burn tokens for reporting

        tokenReports[_tokenAddress].push(Report({
            reporter: msg.sender,
            reason: _reason,
            timestamp: block.timestamp,
            votes: 0,
            ownerResponse: "",
            escalated: false
        }));

        activeReports++;
        updateEscalationThreshold();

        emit TokenReported(_tokenAddress, msg.sender, _reason);
    }

    // Verify ownership and set audit certificate
    function verifyTokenOwnership(
        address _tokenAddress,
        string calldata _contactInfo,
        string calldata _web3Page,
        string calldata _contractType,
        string calldata _auditCertificate
    ) external {
        require(tokenDetails[_tokenAddress].isVerified == false, "Token already verified");
        IERC20Metadata token = IERC20Metadata(_tokenAddress);
        require(msg.sender == token.owner(), "Not token owner");

        tokenDetails[_tokenAddress] = TokenDetails({
            isVerified: true,
            contactInfo: _contactInfo,
            web3Page: _web3Page,
            contractType: _contractType,
            reputation: 0,
            auditCertificate: _auditCertificate
        });

        emit TokenVerified(_tokenAddress, _contactInfo, _web3Page, _contractType);
        emit AuditCertificateUploaded(_tokenAddress, _auditCertificate);
    }

    // Dynamic escalation rule adjustment
    function updateEscalationThreshold() public {
        if (activeReports > 100) escalationThreshold = 20;
        else if (activeReports > 50) escalationThreshold = 15;
        else escalationThreshold = 10;
    }

    // Escalate a report
    function escalateReport(address _tokenAddress, uint256 _reportIndex) external {
        require(_reportIndex < tokenReports[_tokenAddress].length, "Invalid report index");
        Report storage report = tokenReports[_tokenAddress][_reportIndex];
        require(!report.escalated, "Already escalated");

        report.escalated = true;

        emit TokenEscalated(_tokenAddress, _reportIndex);
    }

    // ==============================
    // User Incentives and Engagement
    // ==============================

    // Add a review for a token
    function addReview(address _tokenAddress, string calldata _content) external {
        require(bscamToken.balanceOf(msg.sender) >= VOTING_COST, "Insufficient BSCAM tokens");
        bscamToken.burn(msg.sender, VOTING_COST); // Burn tokens for submitting a review

        tokenReviews[_tokenAddress].push(Review({
            reviewer: msg.sender,
            content: _content,
            upvotes: 0,
            downvotes: 0
        }));

        emit ReviewAdded(_tokenAddress, msg.sender, _content);
    }

    // Upvote or downvote a review
    function voteReview(address _tokenAddress, uint256 _reviewIndex, bool upvote) external {
        require(_reviewIndex < tokenReviews[_tokenAddress].length, "Invalid review index");

        if (upvote) {
            tokenReviews[_tokenAddress][_reviewIndex].upvotes++;
        } else {
            tokenReviews[_tokenAddress][_reviewIndex].downvotes++;
        }
    }

    // Purchase premium access
    function purchaseSubscription() external {
        require(usdc.allowance(msg.sender, address(this)) >= SUBSCRIPTION_COST, "USDC allowance too low");

        bool success = usdc.transferFrom(msg.sender, address(this), SUBSCRIPTION_COST);
        require(success, "USDC transfer failed");

        uint256 newExpiry = block.timestamp + 30 days;
        premiumAccessExpiry[msg.sender] = newExpiry;

        emit SubscriptionPurchased(msg.sender, newExpiry);
    }

    // ==============================
    // Utility Functions
    // ==============================

    // Check if user has premium access
    function hasPremiumAccess(address _user) public view returns (bool) {
        return premiumAccessExpiry[_user] >= block.timestamp;
    }

    // Modifier to restrict premium-only features
    modifier onlyPremium() {
        require(hasPremiumAccess(msg.sender), "Premium access required");
        _;
    }
}

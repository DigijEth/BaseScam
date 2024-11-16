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
        string ownerResponse; // Optional response from the token owner
        bool escalated;
        uint256 votes;
    }

    // Struct to hold token owner details
    struct TokenDetails {
        string contactInfo;
        string web3Page;
        string auditCertificate; // Document link or IPFS hash
        string contractType; // E.g., "Token", "NFT"
    }

    // Struct for reviews
    struct Review {
        address reviewer;
        string content;
        uint256 upvotes;
        uint256 downvotes;
    }

    // Token and admin details
    address public admin;
    BSCAMToken public bscamToken;
    IERC20 public usdc;

    // Pricing and thresholds
    uint256 public constant REPORT_COST = 1 * (10 ** 18); // 1 BSCAM
    uint256 public constant REVIEW_COST = 2 * (10 ** 18); // 2 BSCAM
    uint256 public constant TOKEN_BATCH_COST = 5.99 * (10 ** 6); // $5.99 in USDC
    uint256 public constant PREMIUM_COST = 9.99 * (10 ** 6); // $9.99 in USDC
    uint256 public escalationThreshold = 10; // Initial escalation threshold
    uint256 public activeReports; // Tracks the number of active reports

    // Mappings for data storage
    mapping(address => Report[]) public tokenReports; // Token reports
    mapping(address => TokenDetails) public tokenDetails; // Token owner information
    mapping(address => Review[]) public tokenReviews; // Token reviews
    mapping(address => uint256) public premiumSubscriptions; // Premium access expiration timestamps

    // Events
    event ReportSubmitted(address indexed token, address indexed reporter);
    event ReportVoted(address indexed token, uint256 reportIndex, bool escalated);
    event ReviewSubmitted(address indexed token, address indexed reviewer);
    event ReviewVoted(address indexed token, uint256 reviewIndex, bool upvoted);
    event PremiumPurchased(address indexed user, uint256 expirationTimestamp);
    event TokensPurchased(address indexed user, uint256 amount);

    constructor(BSCAMToken _bscamToken, IERC20 _usdc) {
        admin = msg.sender;
        bscamToken = _bscamToken;
        usdc = _usdc;
    }

    // ==============================
    // Reporting and Voting
    // ==============================

    function submitReport(address _tokenAddress, string calldata _reason) external {
        require(bscamToken.balanceOf(msg.sender) >= REPORT_COST, "Insufficient BSCAM tokens");
        require(bscamToken.transferFrom(msg.sender, address(this), REPORT_COST), "Token transfer failed");

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

        activeReports++;
        updateEscalationThreshold();

        emit ReportSubmitted(_tokenAddress, msg.sender);
    }

    function voteOnReport(address _tokenAddress, uint256 reportIndex) external {
        require(reportIndex < tokenReports[_tokenAddress].length, "Invalid report index");
        require(bscamToken.balanceOf(msg.sender) >= REPORT_COST, "Insufficient BSCAM tokens");
        require(bscamToken.transferFrom(msg.sender, address(this), REPORT_COST), "Token transfer failed");

        Report storage report = tokenReports[_tokenAddress][reportIndex];
        require(!report.escalated, "Report already escalated");

        report.votes++;

        if (report.votes >= escalationThreshold) {
            report.escalated = true;
            activeReports--;
        }

        emit ReportVoted(_tokenAddress, reportIndex, report.escalated);
    }

    // ==============================
    // Token Owner Details
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
            contractType: _contractType
        });
    }

    // ==============================
    // Reviews
    // ==============================

    function submitReview(address _tokenAddress, string calldata _content) external {
        require(bscamToken.balanceOf(msg.sender) >= REVIEW_COST, "Insufficient BSCAM tokens");
        require(bscamToken.transferFrom(msg.sender, address(this), REVIEW_COST), "Token transfer failed");

        tokenReviews[_tokenAddress].push(
            Review({
                reviewer: msg.sender,
                content: _content,
                upvotes: 0,
                downvotes: 0
            })
        );

        emit ReviewSubmitted(_tokenAddress, msg.sender);
    }

    function voteOnReview(address _tokenAddress, uint256 reviewIndex, bool upvote) external {
        require(reviewIndex < tokenReviews[_tokenAddress].length, "Invalid review index");

        Review storage review = tokenReviews[_tokenAddress][reviewIndex];
        if (upvote) {
            review.upvotes++;
        } else {
            review.downvotes++;
        }

        emit ReviewVoted(_tokenAddress, reviewIndex, upvote);
    }

    // ==============================
    // Premium Access and Token Purchases
    // ==============================

    function purchasePremium() external {
        require(usdc.transferFrom(msg.sender, address(this), PREMIUM_COST), "USDC transfer failed");

        uint256 currentExpiration = premiumSubscriptions[msg.sender];
        uint256 newExpiration = block.timestamp > currentExpiration
            ? block.timestamp + 30 days
            : currentExpiration + 30 days;

        premiumSubscriptions[msg.sender] = newExpiration;

        emit PremiumPurchased(msg.sender, newExpiration);
    }

    function purchaseTokens(uint256 amount) external {
        require(amount % 5000 == 0, "Must purchase in batches of 5,000");
        uint256 cost = (amount / 5000) * TOKEN_BATCH_COST;
        require(usdc.transferFrom(msg.sender, address(this), cost), "USDC transfer failed");

        bscamToken.mint(msg.sender, amount);

        emit TokensPurchased(msg.sender, amount);
    }

    // ==============================
    // Escalation Threshold
    // ==============================

    function updateEscalationThreshold() internal {
        if (activeReports > 100) {
            escalationThreshold = 20;
        } else if (activeReports > 50) {
            escalationThreshold = 15;
        } else {
            escalationThreshold = 10;
        }
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

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

    // Voting, reputation, and reports
    mapping(address => uint256) public reputation;
    mapping(address => uint256) public votesInPeriod;
    mapping(address => Report[]) public tokenReports;

    // Blacklist/Whitelist
    mapping(address => bool) public blacklistedTokens;
    mapping(address => bool) public whitelistedTokens;

    // Escalated reports
    mapping(uint256 => bool) public escalatedReports; // Map by report ID

    // Referral tracking
    mapping(address => address) public referrals;
    uint256 public referralReward = 50 * (10 ** 18); // 50 BSCAM tokens

    // Events
    event AdminAction(address indexed admin, string action, uint256 timestamp);
    event TokenVoted(address indexed voter, address indexed token, uint256 amount);
    event TokenReported(address indexed token, address indexed reporter, string reason);
    event TokenBlacklisted(address indexed token);
    event TokenWhitelisted(address indexed token);
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
    // Reporting and Voting
    // ==============================

    function reportToken(address _tokenAddress, string calldata _reason) external {
        require(reputation[msg.sender] >= 0, "Low reputation");
        require(!blacklistedTokens[_tokenAddress], "Token already blacklisted");

        tokenReports[_tokenAddress].push(
            Report({
                reporter: msg.sender,
                reason: _reason,
                timestamp: block.timestamp,
                votes: 0,
                ownerResponse: "",
                escalated: false,
                riskScore: 0
            })
        );

        emit TokenReported(_tokenAddress, msg.sender, _reason);
    }

    function voteOnReport(address _tokenAddress, uint256 reportIndex, bool voteFor) external {
        require(bscamToken.balanceOf(msg.sender) >= 1 * (10 ** 18), "Insufficient BSCAM tokens");
        require(reportIndex < tokenReports[_tokenAddress].length, "Invalid report");

        Report storage report = tokenReports[_tokenAddress][reportIndex];
        require(!report.escalated, "Report already escalated");

        report.votes += 1; // Increment votes
        require(bscamToken.transferFrom(msg.sender, address(this), 1 * (10 ** 18)), "Token transfer failed");

        // Escalate if votes exceed threshold
        if (report.votes >= 5) {
            report.escalated = true;
            escalatedReports[reportIndex] = true;
        }

        emit TokenVoted(msg.sender, _tokenAddress, 1 * (10 ** 18));
    }

    // ==============================
    // Blacklist and Whitelist
    // ==============================

    function blacklistToken(address _tokenAddress) external onlyAdmin {
        require(!blacklistedTokens[_tokenAddress], "Token already blacklisted");
        blacklistedTokens[_tokenAddress] = true;
        emit TokenBlacklisted(_tokenAddress);
    }

    function whitelistToken(address _tokenAddress) external onlyAdmin {
        require(!whitelistedTokens[_tokenAddress], "Token already whitelisted");
        whitelistedTokens[_tokenAddress] = true;
        emit TokenWhitelisted(_tokenAddress);
    }

    // ==============================
    // Insurance Pool
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

    // ==============================
    // Premium Access via NFTs
    // ==============================

    function mintPremiumNFT(address user, string calldata nftURI) external onlyAdmin {
        // Placeholder logic for NFT minting
        emit NFTPremiumAccessMinted(user, nftURI);
    }

    // ==============================
    // Admin Functions
    // ==============================

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can perform this action");
        _;
    }

    function updateReferralReward(uint256 newReward) external onlyAdmin {
        referralReward = newReward;
    }
}

// SPDX-License-Identifier: See Github
pragma solidity ^0.8.0;

import "./BSCAMToken.sol";

contract TokenReportRegistry {
    // Struct to hold report details
    struct Report {
        address reporter;
        string reason;
        uint256 timestamp;
        uint256 votes;
    }

    // Mapping from token address to list of reports
    mapping(address => Report[]) public tokenReports;

    // Mapping to check if a reporter has already reported a token
    mapping(address => mapping(address => bool)) public hasReported;

    // Admin address (optional)
    address public admin;

    // Instance of BSCAM token contract
    BSCAMToken public bscamToken;

    // Voting cost
    uint256 public constant VOTING_COST = 1 * (10 ** 18); // 1 BSCAM token (assuming 18 decimals)

    // Events
    event TokenReported(address indexed tokenAddress, address indexed reporter, string reason);
    event TokenCleared(address indexed tokenAddress);
    event VoteCast(address indexed tokenAddress, uint256 reportIndex, address indexed voter);

    constructor(BSCAMToken _bscamToken) {
        admin = msg.sender; // Set deployer as admin
        bscamToken = _bscamToken; // Assign the BSCAM token contract
    }

    // Function to report a token
    function reportToken(address _tokenAddress, string calldata _reason) external {
        require(_tokenAddress != address(0), "Invalid token address");
        require(!hasReported[_tokenAddress][msg.sender], "You have already reported this token");

        // Record the report
        tokenReports[_tokenAddress].push(Report({
            reporter: msg.sender,
            reason: _reason,
            timestamp: block.timestamp,
            votes: 0
        }));

        hasReported[_tokenAddress][msg.sender] = true;

        emit TokenReported(_tokenAddress, msg.sender, _reason);
    }

    // Function to vote on a report
    function voteOnReport(address _tokenAddress, uint256 _reportIndex) external {
        require(_reportIndex < tokenReports[_tokenAddress].length, "Invalid report index");

        // Transfer 1 BSCAM token from the voter to the contract
        require(bscamToken.transferFrom(msg.sender, address(this), VOTING_COST), "Vote payment failed");

        // Increment the vote count for the report
        tokenReports[_tokenAddress][_reportIndex].votes += 1;

        emit VoteCast(_tokenAddress, _reportIndex, msg.sender);
    }

    // Function to get the number of reports for a token
    function getReportCount(address _tokenAddress) external view returns (uint256) {
        return tokenReports[_tokenAddress].length;
    }

    // Function to get reports for a token
    function getReports(address _tokenAddress) external view returns (Report[] memory) {
        return tokenReports[_tokenAddress];
    }

    // Admin function to clear reports (optional)
    function clearReports(address _tokenAddress) external onlyAdmin {
        delete tokenReports[_tokenAddress];

        emit TokenCleared(_tokenAddress);
    }

    // Modifier for admin-only functions
    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can perform this action");
        _;
    }

    // Function to transfer admin rights
    function transferAdmin(address _newAdmin) external onlyAdmin {
        require(_newAdmin != address(0), "Invalid address");
        admin = _newAdmin;
    }
}

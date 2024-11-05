# BaseScammer Server

This is the server-side application for the BaseScammer DApp. It handles API keys securely, interacts with external APIs like Token Sniffer and CoinGecko, and provides endpoints for the DApp to fetch data.

## Features

- Scans the Basechain network for new tokens.
- Analyzes tokens using the Token Sniffer API.
- Fetches additional token information from CoinGecko.
- Stores token data in MongoDB.
- Provides REST API endpoints for the client to fetch token data.

## Prerequisites

- Node.js and npm installed.
- MongoDB installed and running.
- API keys for Token Sniffer (and CoinGecko if needed).

## Setup Instructions

1. **Clone the repository** or copy the server directory into your project.

2. **Navigate to the server directory:**

   ```bash
   cd basescammer-dapp/server

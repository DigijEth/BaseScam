# BaseScammer Server

This is the server-side application for the BaseScammer DApp. It handles API keys securely, interacts with external APIs like Token Sniffer and CoinGecko, and provides endpoints for the DApp to fetch data.

## Features

- Scans the Basechain network for new tokens.
- Analyzes tokens using the Token Sniffer API.
- Fetches additional token information from CoinGecko.
- Stores token data in MongoDB.
- Provides REST API endpoints for the client to fetch token 

---

## **Prerequisites**

- **Node.js** and **npm** installed.
- **MongoDB** installed and running.
- **API Keys**:
  - **Token Sniffer API Key** (obtain from [Token Sniffer](https://tokensniffer.com/)).
  - **CoinGecko API Key** is optional since the public endpoints are used.

---

## **Setup Instructions**

### **1. Navigate to the Server Directory**

```bash
cd basescammer-dapp/server
```

### **2. Install Dependencies**

```bash
npm install
```

This installs all the required packages specified in `package.json`.

### **3. Configure Environment Variables**

Create a `.env` file in the server directory:

```dotenv
PORT=5000
BASECHAIN_RPC_URL=https://mainnet.base.org
TOKEN_SNIFFER_API_KEY=YOUR_TOKEN_SNIFFER_API_KEY
MONGODB_URI=mongodb://localhost:27017/basescammer
```

- **PORT**: The port the server will run on.
- **BASECHAIN_RPC_URL**: The RPC URL for the Basechain network.
- **TOKEN_SNIFFER_API_KEY**: Your Token Sniffer API key.
- **MONGODB_URI**: Connection string for MongoDB.

Ensure that MongoDB is running on your machine and accessible via the specified URI.

### **4. Start the Server**

```bash
npm start
```

The server will start and listen on the port specified in `.env` (default is 5000).

---

## **Server Functionality**

### **1. Scanning Basechain**

- The `tokenScanner` module scans the Basechain network for new tokens every few seconds (adjustable).
- It checks recent blocks for contract creation transactions.
- For each new contract, it tries to interact with it as an ERC-20 token.
- If successful, it fetches the token's name, symbol, and total supply.

### **2. Analyzing Tokens**

- Uses the **Token Sniffer API** to analyze tokens.
- Determines if a token is potentially a scam or has a low score.
- Stores the analysis results in the token document.

### **3. Fetching Token Information**

- Uses the **CoinGecko API** to fetch additional token data like market cap and circulating supply.
- Stores this data in the token document.

### **4. Database Storage**

- Tokens are stored in a MongoDB database.
- Each token has fields like `name`, `symbol`, `contractAddress`, `status`, `message`, `score`, etc.

### **5. API Endpoint**

- **GET /api/tokens**: Returns a list of tokens from the database.
  - Supports query parameters for pagination (`offset`, `limit`) and searching (`searchQuery`).

---

## **Connecting the Client to the Server**

### **1. Update Client Configuration**

In the client code (`client/src/utils/api.js`), modify the `fetchTokens` function to fetch data from the server instead of scanning the blockchain directly.

**Updated `fetchTokens` function:**

```javascript
// client/src/utils/api.js

export async function fetchTokens(offset = 0, limit = 50, searchQuery = '') {
  try {
    const response = await fetch(`http://localhost:5000/api/tokens?offset=${offset}&limit=${limit}&searchQuery=${searchQuery}`);
    const tokens = await response.json();
    return tokens;
  } catch (error) {
    console.error('Error fetching tokens from server:', error);
    return [];
  }
}
```

Ensure that the URL points to your server's API endpoint.

### **2. Adjust Client-Side Scanning Logic**

Since the server handles scanning and data fetching, remove or adjust any client-side code that scans the blockchain or interacts with external APIs.

---

## **Security Enhancements**

- **API Keys:** API keys are securely stored in the server's `.env` file and are not exposed to the client.

- **CORS Configuration:** The server allows cross-origin requests. Adjust the CORS settings in `app.js` if you need to restrict access.

---

## **Important Considerations**

- **Performance:**

  - Scanning the blockchain is resource-intensive.
  - The scan interval is set to every 3 seconds (`setInterval(scanBasechain, 3000);`). Adjust this as needed.
  - Using a database improves performance by caching results.

- **Data Accuracy:**

  - Tokens may not be immediately available on CoinGecko after creation.
  - The holders count and liquidity pool information may not be available directly and may require additional methods or APIs.

- **Error Handling:**

  - Ensure proper error handling in both the server and client to handle exceptions gracefully.

- **Legal and Ethical Considerations:**

  - Comply with the terms of service of the Basechain network, Token Sniffer API, and CoinGecko API.
  - Respect user privacy and data protection regulations.

---

## **Testing the Application**

- **Start MongoDB:**

  Ensure MongoDB is running:

  ```bash
  mongod
  ```

- **Start the Server:**

  ```bash
  npm start
  ```

- **Start the Client:**

  In a separate terminal, navigate to the client directory and start the client application:

  ```bash
  cd ../client
  npm start
  ```

- **Test the Application:**

  - Open the client application in your browser (`http://localhost:3000`).
  - The client should now fetch token data from the server.
  - Use the search and pagination features to interact with the token list.

---

## **Future Enhancements**

- **Holders Count and Liquidity Pool:**

  - Implement methods to fetch holders count and liquidity pool data, possibly using blockchain analytics APIs or services.

- **Authentication and Security:**

  - Implement user authentication if needed.
  - Secure API endpoints with authentication tokens.

- **Admin Dashboard:**

  - Create an admin interface to monitor the server's performance and manage tokens.

- **Deployment:**

  - Deploy the server and client applications to a cloud platform.
  - Use environment variables to manage configurations in production.

---

## **Conclusion**

You now have the server-side code for the **BaseScammer DApp** that securely handles API keys, interacts with external APIs, and provides data to the client application.

This setup enhances security by:

- Keeping API keys on the server-side.
- Handling API requests and data processing on the server.
- Providing a clean API for the client to consume.

Feel free to customize and extend the application further according to your needs.

---

**Note:** As an AI language model developed by OpenAI, I cannot create zip files or provide documents for download. However, you can copy the provided code into your project files accordingly.

If you have any questions or need further assistance, feel free to ask!

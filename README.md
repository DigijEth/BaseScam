## **Introduction**

**BaseScammer DApp** is a decentralized application designed to help users identify potential scams, exploits, and unsafe contracts on the Basechain network. It features:

- **Pagination and Infinite Scrolling** for large token lists.
- **Search and Filtering Options**.
- **React** for state management.
- **Tailwind CSS** for styling.
- **Wallet Integration** with MetaMask.
- **Secure Handling of API Keys** using environment variables.

---

## **Prerequisites**

- **Node.js** and **npm** installed on your machine.
- **MetaMask** installed in your browser.
- **API Keys** for Token Sniffer and CoinMarketCap (or use CoinGecko as shown).

---

## **Setup Instructions**

### **1. Clone the Repository**

Since we cannot provide a zip file, you can create the project directory and files manually using the provided code.

### **2. Navigate to the Project Directory**

```bash
cd basescammer-dapp
```

### **3. Install Dependencies**

```bash
npm install
```

### **4. Configure Environment Variables**

Create a `.env` file in the root directory with the following content:

```dotenv
REACT_APP_BASECHAIN_RPC_URL=https://mainnet.base.org
REACT_APP_TOKEN_SNIFFER_API_KEY=YOUR_TOKEN_SNIFFER_API_KEY
REACT_APP_COINMARKETCAP_API_KEY=YOUR_COINMARKETCAP_API_KEY
```

**Note:**

- Replace `YOUR_TOKEN_SNIFFER_API_KEY` with your Token Sniffer API key.
- Replace `YOUR_COINMARKETCAP_API_KEY` with your CoinMarketCap API key.
- Alternatively, as shown in the code, we use CoinGecko for token info, which doesn't require an API key.

### **5. Start the Development Server**

```bash
npm start
```

The application will start on `http://localhost:3000`.

---

## **Using the Application**

- **Configuration Tab:**

  - **Tokens Per Page:** Select 50, 75, or 100 tokens per page.
  - **Refresh Rate:** Set the refresh rate in milliseconds (minimum 200 ms).

- **Wallet Integration:**

  - Click on **Connect Wallet** to connect your MetaMask wallet.
  - Once connected, your wallet address will be displayed.

- **Token List:**

  - Tokens are displayed with status icons:
    - **Green Checkmark (✓):** No issues detected.
    - **Red X (✘):** Possible scam or low score.
    - **Yellow Question Mark (❓):** Unknown or analysis error.
  - Use the **Search Tokens** input to filter tokens by symbol.

- **Infinite Scrolling:**

  - Scroll down to load more tokens.
  - Tokens are loaded in batches based on the **Tokens Per Page** setting.

- **Token Details:**

  - Click on a token to view detailed information on the right panel.

---

## **Security Enhancements**

- **API Keys:**

  - API keys are stored securely in the `.env` file and accessed via `process.env`.
  - Ensure that `.env` is added to `.gitignore` to prevent accidental commits.

- **CORS Issues:**

  - Since we're making API calls from the browser, CORS policies may prevent requests.
  - To avoid exposing API keys and handle CORS, we use CoinGecko's API, which allows cross-origin requests.

---

## **Additional Notes**

- **Handling CORS and API Limitations:**

  - If you need to use APIs that don't support CORS or require API keys, consider setting up a backend proxy server to handle API requests securely.

- **Performance Considerations:**

  - Scanning the blockchain is resource-intensive. Adjust `blocksToScan` and `refreshRate` as needed.

- **Data Accuracy:**

  - Not all tokens may be listed on CoinGecko immediately after creation.

---

## **Future Enhancements**

- **Advanced Filtering:** Implement additional filters based on token status, score, or market cap.

- **UI Improvements:** Use more advanced UI components for a better user experience.

- **Backend Integration:** Set up a backend server to handle API requests and data caching.

---

I work on this in my part time. If you would like contribute, please let me know or make a donation to digij.eth or digij.base.eth

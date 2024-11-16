The readme for the Security Token is in the
in the folder labeled /onchain-app/ The main
function comes from the Contract and Token 
interactions.

## **Overview**

**BaseScammer** is an application designed to scan the Basechain network for new tokens, analyze them for potential risks using the Token Sniffer API, and display the results in an accessible format. It includes:

- A **Web Application** for users to view tokens and their analysis.
- A **Decentralized Application (DApp)** for blockchain enthusiasts.
- A **WordPress Plugin** for integrating the token scanner into WordPress websites.

---

## **Table of Contents**

1. [Web Server](#web-server)
    - [Prerequisites](#prerequisites)
    - [Setup Instructions](#setup-instructions)
    - [Server Structure](#server-structure)
    - [Starting the Server](#starting-the-server)
2. [DApp](#dapp)
    - [Prerequisites](#prerequisites-1)
    - [Setup Instructions](#setup-instructions-1)
    - [Connecting to the Server](#connecting-to-the-server)
3. [WordPress Plugin](#wordpress-plugin)
    - [Installation](#installation)
    - [Configuration](#configuration)
    - [Usage](#usage)
4. [API Endpoints](#api-endpoints)
5. [Important Notes](#important-notes)
6. [License](#license)

---

## **Web Server**

### **Prerequisites**

- **Node.js** and **npm** installed.
- **MongoDB** installed and running, or use **MongoDB Atlas** for cloud deployment.
- **API keys** for Token Sniffer (and CoinGecko if needed).

### **Setup Instructions**

1. **Clone the repository** or copy the `basescammer-webapp` directory into your project.

2. **Navigate to the server directory:**

   ```bash
   cd basescammer-webapp/server
   ```

3. **Install dependencies:**

   ```bash
   npm install
   ```

4. **Configure environment variables:**

   Create a `.env` file in the server directory with the following content:

   ```dotenv
   PORT=5000
   BASECHAIN_RPC_URL=https://mainnet.base.org
   TOKEN_SNIFFER_API_KEY=YOUR_TOKEN_SNIFFER_API_KEY
   MONGODB_URI=mongodb+srv://username:password@cluster0.mongodb.net/?retryWrites=true&w=majority
   NODE_ENV=production
   ```

   - Replace `YOUR_TOKEN_SNIFFER_API_KEY` with your actual Token Sniffer API key.
   - Ensure MongoDB is running and the URI is correct.

5. **Start the server:**

   ```bash
   npm start
   ```

   The server will start on `http://localhost:5000`.

### **Server Structure**

The server directory contains:

- `app.js`: Main server application.
- `routes/`: Contains API and web routes.
- `controllers/`: Contains controllers for handling requests.
- `models/`: Contains Mongoose models.
- `utils/`: Contains utility functions like `tokenScanner`.
- `views/`: Contains EJS templates for rendering web pages.
- `public/`: Contains static assets.

### **Starting the Server**

- **Development Mode:**

  ```bash
  npm run dev
  ```

- **Production Mode:**

  ```bash
  npm start
  ```

---

## **DApp**

### **Prerequisites**

- **Node.js** and **npm** installed.
- **MetaMask** or compatible Ethereum wallet installed in your browser.

### **Setup Instructions**

1. **Navigate to the DApp directory:**

   ```bash
   cd basescammer-dapp
   ```

2. **Install dependencies:**

   ```bash
   npm install
   ```

3. **Start the DApp:**

   ```bash
   npm start
   ```

4. **Access the DApp:**

   Open `http://localhost:3000` in your browser.

### **Connecting to the Server**

The DApp communicates with the server API to fetch token data. Ensure the server is running and accessible.

In the DApp code (`src/utils/api.js`), update the `SERVER_URL` to point to your server:

```javascript
const SERVER_URL = 'https://your-server-url.com';
```

---

## **WordPress Plugin**

### **Installation**

1. **Copy the plugin directory:**

   Copy the `basescammer-wordpress-plugin` folder to your WordPress `wp-content/plugins/` directory.

2. **Activate the plugin:**

   - Log in to your WordPress admin dashboard.
   - Navigate to `Plugins` > `Installed Plugins`.
   - Find `BaseScammer` and click `Activate`.

### **Configuration**

1. **Settings:**

   - Go to `Settings` > `BaseScammer`.
   - Configure:
     - **Tokens Per Page:** Choose between 50, 75, or 100.
     - **Refresh Rate:** Set the refresh rate in milliseconds (minimum 200 ms).
   - Click `Save Settings`.

2. **API URL:**

   - Ensure the `api_url` in `basescammer.php` points to your server's API endpoint.

   ```php
   'api_url'  => 'https://your-server-url.com/api/tokens',
   ```

### **Usage**

- **Add the shortcode** `[basescammer_scanner]` to any page or post where you want the token scanner to appear.

---

## **API Endpoints**

- **GET `/api/tokens`**

  Fetches tokens from the database.

  **Query Parameters:**

  - `offset` (optional): Number of tokens to skip.
  - `limit` (optional): Number of tokens to return.
  - `searchQuery` (optional): Search term for token symbol.

  **Example:**

  ```http
  GET https://your-server-url.com/api/tokens?offset=0&limit=50&searchQuery=ETH
  ```

---

## **Important Notes**

- **CORS:** The server is configured to accept requests from any origin. Adjust the CORS settings in `app.js` if needed.

- **Security:** Keep your API keys secure and do not expose them in client-side code.

- **Performance:** Adjust the scanning interval in `tokenScanner.js` as needed.


```markdown
## License

This project is licensed under a Dual-Use License.

- Personal Use/Education: Free for personal, non-commercial purposes.
- Commercial Use: Requires a commercial license.

Please see the LICENSE file for the full terms.

For commercial licensing inquiries, please contact:

- Email: [fightwithmusicinc@gmail.com]
```

--

**Note:** Replace placeholders like `YOUR_TOKEN_SNIFFER_API_KEY` and `https://your-server-url.com` with your actual API key and server URL.

If you have any questions or need further assistance, feel free to ask!

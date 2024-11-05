## **README**

# BaseScammer: Web Application, DApp, and WordPress Plugin

## **Overview**

**BaseScammer** is an application designed to scan the Basechain network for new tokens, analyze them for potential risks using the Token Sniffer API, and display the results in an accessible format. It includes:

- A **Web Application** for users to view tokens and their analysis.
- A **Decentralized Application (DApp)** for blockchain enthusiasts.
- A **WordPress Plugin** for integrating the token scanner into WordPress websites.

This is just the beginning. I plan on expanding this to include more features
such as wallet/contract mapping to trace scammers, top holders 

If you would like to contribute please let me know or donate at digij.eth or digij.base.eth
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

- **Legal and Ethical Considerations:**

  - Ensure compliance with the terms of service of the Basechain network, Token Sniffer API, and CoinGecko API.
  - Respect user privacy and data protection regulations.

---

## **License**

MIT

---

# **Conclusion**

With this setup, you have a fully functional BaseScammer application that includes:

- A web application accessible via a browser.
- A DApp for decentralized interaction.
- A WordPress plugin for easy integration into WordPress sites.

Feel free to customize and extend the application further according to your needs.

---

**Note:** Replace placeholders like `YOUR_TOKEN_SNIFFER_API_KEY` and `https://your-server-url.com` with your actual API key and server URL.

If you have any questions or need further assistance, feel free to ask!Certainly! Below are the code blocks for the new WordPress plugin based on the previous one, along with their file names and locations. After that, I have provided a README file that covers the web server, DApp, and WordPress plugin.

---

## **WordPress Plugin**

### **Project Structure**

```
basescammer-wordpress-plugin/
├── basescammer.php
├── css/
│   └── styles.css
├── js/
│   └── scripts.js
└── templates/
    └── scanner.php
```

---

### **1. `basescammer.php`**

**Location:** `basescammer-wordpress-plugin/basescammer.php`

```php
<?php
/*
Plugin Name: BaseScammer
Description: Displays tokens from Basechain scanned by the Token Sniffer API.
Version: 1.0
Author: Your Name
*/

if (!defined('ABSPATH')) exit; // Exit if accessed directly

// Enqueue scripts and styles
function basescammer_enqueue_scripts() {
    wp_enqueue_style('basescammer-styles', plugin_dir_url(__FILE__) . 'css/styles.css');
    wp_enqueue_script('basescammer-scripts', plugin_dir_url(__FILE__) . 'js/scripts.js', array('jquery'), null, true);
    wp_localize_script('basescammer-scripts', 'basescammer_ajax_object', array(
        'ajax_url' => admin_url('admin-ajax.php'),
        'nonce'    => wp_create_nonce('basescammer_nonce'),
        'api_url'  => 'https://your-server-url.com/api/tokens', // Replace with your server URL
        'tokens_per_page' => get_option('basescammer_tokens_per_page', 50),
        'refresh_rate'    => get_option('basescammer_refresh_rate', 300),
    ));
}
add_action('wp_enqueue_scripts', 'basescammer_enqueue_scripts');

// Shortcode to display the token scanner
function basescammer_display_scanner($atts) {
    $atts = shortcode_atts(array(
        'display' => 'option1', // 'option1' or 'option2'
    ), $atts, 'basescammer_scanner');

    ob_start();
    include plugin_dir_path(__FILE__) . 'templates/scanner.php';
    return ob_get_clean();
}
add_shortcode('basescammer_scanner', 'basescammer_display_scanner');

// Add settings menu
function basescammer_add_settings_menu() {
    add_options_page('BaseScammer Settings', 'BaseScammer', 'manage_options', 'basescammer-settings', 'basescammer_render_settings_page');
}
add_action('admin_menu', 'basescammer_add_settings_menu');

// Render settings page
function basescammer_render_settings_page() {
    if (!current_user_can('manage_options')) {
        return;
    }

    // Save settings
    if (isset($_POST['basescammer_settings_submit'])) {
        check_admin_referer('basescammer_settings_nonce');
        update_option('basescammer_tokens_per_page', intval($_POST['basescammer_tokens_per_page']));
        $refresh_rate = max(intval($_POST['basescammer_refresh_rate']), 200);
        update_option('basescammer_refresh_rate', $refresh_rate);
        echo '<div class="updated"><p>Settings saved.</p></div>';
    }

    // Get settings
    $tokens_per_page = get_option('basescammer_tokens_per_page', 50);
    $refresh_rate = get_option('basescammer_refresh_rate', 300);

    ?>
    <div class="wrap">
        <h1>BaseScammer Settings</h1>
        <form method="post">
            <?php wp_nonce_field('basescammer_settings_nonce'); ?>
            <table class="form-table">
                <tr>
                    <th scope="row"><label for="basescammer_tokens_per_page">Tokens Per Page</label></th>
                    <td>
                        <select id="basescammer_tokens_per_page" name="basescammer_tokens_per_page">
                            <option value="50" <?php selected($tokens_per_page, 50); ?>>50</option>
                            <option value="75" <?php selected($tokens_per_page, 75); ?>>75</option>
                            <option value="100" <?php selected($tokens_per_page, 100); ?>>100</option>
                        </select>
                    </td>
                </tr>
                <tr>
                    <th scope="row"><label for="basescammer_refresh_rate">Refresh Rate (ms)</label></th>
                    <td><input type="number" id="basescammer_refresh_rate" name="basescammer_refresh_rate" value="<?php echo esc_attr($refresh_rate); ?>" min="200" required></td>
                </tr>
            </table>
            <?php submit_button('Save Settings', 'primary', 'basescammer_settings_submit'); ?>
        </form>
    </div>
    <?php
}
```

---

### **2. `css/styles.css`**

**Location:** `basescammer-wordpress-plugin/css/styles.css`

```css
#basescammer-container {
    display: flex;
    height: 500px;
    border: 1px solid #ddd;
}

#basescammer-left-panel {
    width: 30%;
    border-right: 1px solid #ddd;
    overflow-y: auto;
    padding: 10px;
}

#basescammer-right-panel {
    flex-grow: 1;
    padding: 10px;
    overflow-y: auto;
}

.basescammer-token-item {
    display: flex;
    align-items: center;
    cursor: pointer;
    padding: 5px;
    border-bottom: 1px solid #eee;
}

.basescammer-token-item:hover {
    background-color: #f9f9f9;
}

.basescammer-status-icon {
    margin-right: 10px;
    font-size: 1.5em;
}

.basescammer-green-check {
    color: green;
}

.basescammer-red-x {
    color: red;
}

.basescammer-yellow-question {
    color: orange;
}

.basescammer-token-name {
    flex-grow: 1;
}

#basescammer-loading {
    text-align: center;
    margin-top: 20px;
}
```

---

### **3. `js/scripts.js`**

**Location:** `basescammer-wordpress-plugin/js/scripts.js`

```javascript
jQuery(document).ready(function($) {
    var tokensPerPage = parseInt(basescammer_ajax_object.tokens_per_page) || 50;
    var refreshRate = parseInt(basescammer_ajax_object.refresh_rate) || 300;

    function fetchTokens() {
        $.ajax({
            url: basescammer_ajax_object.api_url + '?limit=' + tokensPerPage,
            method: 'GET',
            success: function(data) {
                if (Array.isArray(data)) {
                    displayTokens(data);
                } else {
                    $('#basescammer-loading').text('Error: Invalid data received.');
                }
            },
            error: function() {
                $('#basescammer-loading').text('Error fetching tokens.');
            }
        });
    }

    function displayTokens(tokens) {
        var $tokenList = $('#basescammer-token-list');
        $tokenList.empty();

        tokens.forEach(function(token) {
            var statusIcon;
            if (token.status === 'Green') {
                statusIcon = '<span class="basescammer-status-icon basescammer-green-check">&#10004;</span>';
            } else if (token.status === 'Red') {
                statusIcon = '<span class="basescammer-status-icon basescammer-red-x">&#10060;</span>';
            } else {
                statusIcon = '<span class="basescammer-status-icon basescammer-yellow-question">&#10067;</span>';
            }

            var $tokenItem = $('<div class="basescammer-token-item">' + statusIcon + '<span class="basescammer-token-name">' + token.symbol + ' (' + token.name + ')</span></div>');
            $tokenItem.data('token', token);

            $tokenItem.click(function() {
                displayTokenInfo($(this).data('token'));
            });

            $tokenList.append($tokenItem);
        });
    }

    function displayTokenInfo(token) {
        var $tokenInfo = $('#basescammer-token-info');
        $tokenInfo.html(
            '<h3>' + token.symbol + ' (' + token.name + ')</h3>' +
            '<p><strong>Status:</strong> ' + token.status + '</p>' +
            '<p><strong>Score:</strong> ' + (token.score !== null ? token.score : 'N/A') + '</p>' +
            '<p><strong>Message:</strong> ' + token.message + '</p>' +
            '<p><strong>Market Cap:</strong> ' + (token.marketCap !== null ? '$' + token.marketCap : 'N/A') + '</p>' +
            '<p><strong>Total Supply:</strong> ' + (token.totalSupply !== null ? token.totalSupply : 'N/A') + '</p>' +
            '<p><strong>Circulating Supply:</strong> ' + (token.circulatingSupply !== null ? token.circulatingSupply : 'N/A') + '</p>' +
            '<p><strong>Liquidity Pool:</strong> ' + (token.liquidityPool !== null ? token.liquidityPool : 'N/A') + '</p>' +
            '<p><strong>Holders Count:</strong> ' + (token.holdersCount !== null ? token.holdersCount : 'N/A') + '</p>' +
            '<p><strong>Contract Address:</strong> ' + token.contractAddress + '</p>'
        );
    }

    fetchTokens();
    setInterval(fetchTokens, refreshRate);
});
```

---

### **4. `templates/scanner.php`**

**Location:** `basescammer-wordpress-plugin/templates/scanner.php`

```php
<?php if (!defined('ABSPATH')) exit; ?>
<div id="basescammer-container">
    <div id="basescammer-left-panel">
        <div id="basescammer-loading">Loading tokens...</div>
        <div id="basescammer-token-list"></div>
    </div>
    <div id="basescammer-right-panel">
        <h2>Select a token to view details</h2>
        <div id="basescammer-token-info"></div>
    </div>
</div>
```

---

## **README**

# BaseScammer: Web Application, DApp, and WordPress Plugin

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

- **Legal and Ethical Considerations:**

  - Ensure compliance with the terms of service of the Basechain network, Token Sniffer API, and CoinGecko API.
  - Respect user privacy and data protection regulations.

---

## **License**

MIT

---

# **Conclusion**

With this setup, you have a fully functional BaseScammer application that includes:

- A web application accessible via a browser.
- A DApp for decentralized interaction.
- A WordPress plugin for easy integration into WordPress sites.

Feel free to customize and extend the application further according to your needs.

---

**Note:** Replace placeholders like `YOUR_TOKEN_SNIFFER_API_KEY` and `https://your-server-url.com` with your actual API key and server URL.

If you have any questions or need further assistance, feel free to ask!

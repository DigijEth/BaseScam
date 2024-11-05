
Cloud version of the **BaseScammer Server**. This will involve:
Stand alone version in the dapp folder.

- **Deploying the server to a cloud platform** such as **Heroku**, **AWS Elastic Beanstalk**, or **DigitalOcean**.
- **Configuring environment variables** securely on the cloud platform.
- **Setting up a managed MongoDB instance** using a service like **MongoDB Atlas**.
- **Adjusting any necessary configurations** in your server code for cloud deployment.

---

# **Deploying BaseScammer Server to the Cloud**

For this guide, I'll use **Heroku** as the cloud platform because it's developer-friendly, offers a free tier, and simplifies deployment for Node.js applications. You can choose another platform if you prefer, and the steps will be similar.

## **Prerequisites**

- **Heroku Account**: Sign up for a free account at [heroku.com](https://www.heroku.com/).
- **Heroku CLI**: Install the Heroku Command Line Interface from [devcenter.heroku.com/articles/heroku-cli](https://devcenter.heroku.com/articles/heroku-cli).
- **Git**: Ensure Git is installed on your machine.
- **MongoDB Atlas Account**: Sign up for a free account at [mongodb.com/cloud/atlas](https://www.mongodb.com/cloud/atlas).
- **Node.js and npm**: Already installed as per previous setup.

---

## **1. Set Up MongoDB Atlas**

Since we can't host MongoDB on Heroku, we'll use **MongoDB Atlas**, which provides free cloud-hosted MongoDB instances.

### **a. Create a MongoDB Atlas Cluster**

1. **Sign Up**: Go to [mongodb.com/cloud/atlas](https://www.mongodb.com/cloud/atlas) and sign up.
2. **Create a New Project**: Name it `BaseScammer`.
3. **Build a Cluster**:
   - Choose the **Free Shared Cluster** (AWS, M0 Sandbox).
   - Select the region closest to your Heroku app (e.g., `US East (N. Virginia)`).
   - Leave other settings as default and click **Create Cluster**.

### **b. Configure Database Access**

1. **Create a Database User**:
   - Go to **Database Access**.
   - Click **Add New Database User**.
   - Choose **Password** as the authentication method.
   - Enter a username and password (remember these for later).
   - Set **Database User Privileges** to **Read and Write to any database**.
   - Click **Add User**.

### **c. Whitelist IP Address**

1. **Network Access**:
   - Go to **Network Access**.
   - Click **Add IP Address**.
   - Choose **Allow Access from Anywhere** (`0.0.0.0/0`).
   - Confirm the security warning and click **Confirm**.

### **d. Get the Connection String**

1. **Connect to Your Cluster**:
   - From **Clusters**, click **Connect**.
   - Choose **Connect Your Application**.
   - Select **Node.js** and version **4.0 or later**.
   - Copy the connection string. It will look like:

     ```
     mongodb+srv://<username>:<password>@cluster0.mongodb.net/?retryWrites=true&w=majority
     ```

2. **Update the Connection String**:
   - Replace `<username>` and `<password>` with your database user's credentials.
   - The updated connection string will be used as the `MONGODB_URI` in your `.env` file.

---

## **2. Prepare the Server for Deployment**

### **a. Update `package.json`**

Ensure your `package.json` includes a start script that Heroku can use.

**Location:** `basescammer-dapp/server/package.json`

```json
"scripts": {
  "start": "node app.js",
  "dev": "nodemon app.js"
},
```

This is already in place from earlier.

### **b. Ensure Port Configuration**

Heroku sets the port via the `PORT` environment variable. Modify `app.js` to use this variable.

**Location:** `basescammer-dapp/server/app.js`

```javascript
const PORT = process.env.PORT || 5000;
```

This line is already present, so no changes are needed.

### **c. Remove `nodemon` from Dependencies**

Heroku doesn't need `nodemon`. Ensure it's in `devDependencies` and not `dependencies`.

---

## **3. Create a Git Repository**

If you haven't already, initialize a Git repository in the `server` directory.

```bash
cd basescammer-dapp/server
git init
git add .
git commit -m "Initial commit for cloud deployment"
```

---

## **4. Create a Heroku App**

### **a. Login to Heroku CLI**

```bash
heroku login
```

Follow the prompts to log in.

### **b. Create a New Heroku App**

```bash
heroku create basescammer-server
```

Replace `basescammer-server` with a unique name if needed.

---

## **5. Configure Environment Variables on Heroku**

Set the environment variables on Heroku using the Heroku CLI.

```bash
heroku config:set BASECHAIN_RPC_URL=https://mainnet.base.org \
TOKEN_SNIFFER_API_KEY=your_token_sniffer_api_key \
MONGODB_URI=your_mongodb_connection_string \
NODE_ENV=production
```

- **BASECHAIN_RPC_URL**: The Basechain RPC URL.
- **TOKEN_SNIFFER_API_KEY**: Your Token Sniffer API key.
- **MONGODB_URI**: The connection string from MongoDB Atlas.
- **NODE_ENV**: Set to `production`.

**Example:**

```bash
heroku config:set BASECHAIN_RPC_URL=https://mainnet.base.org \
TOKEN_SNIFFER_API_KEY=your_token_sniffer_api_key \
MONGODB_URI=mongodb+srv://username:password@cluster0.mongodb.net/?retryWrites=true&w=majority \
NODE_ENV=production
```

**Important:** Do not include `.env` file in your Git repository. Heroku uses its own environment variables.

---

## **6. Deploy to Heroku**

### **a. Add and Commit Changes**

```bash
git add .
git commit -m "Prepare server for Heroku deployment"
```

### **b. Push to Heroku**

```bash
git push heroku master
```

If you are on a branch other than `master`, use:

```bash
git push heroku your-branch-name:master
```

Heroku will build and deploy your application.

### **c. Verify Deployment**

After deployment, you can check the logs:

```bash
heroku logs --tail
```

---

## **7. Update the Client Application**

### **a. Change the API Endpoint**

In your client application (`client/src/utils/api.js`), update the `fetchTokens` function to use the Heroku server URL.

**Location:** `basescammer-dapp/client/src/utils/api.js`

```javascript
const SERVER_URL = 'https://basescammer-server.herokuapp.com'; // Replace with your Heroku app URL

export async function fetchTokens(offset = 0, limit = 50, searchQuery = '') {
  try {
    const response = await fetch(`${SERVER_URL}/api/tokens?offset=${offset}&limit=${limit}&searchQuery=${searchQuery}`);
    const tokens = await response.json();
    return tokens;
  } catch (error) {
    console.error('Error fetching tokens from server:', error);
    return [];
  }
}
```

### **b. Handle CORS Issues**

Heroku allows all origins by default. If you encounter CORS issues, adjust the CORS middleware in your server code.

**Location:** `basescammer-dapp/server/app.js`

```javascript
// Allow requests from your client application
app.use(cors({
  origin: 'https://your-client-app-url', // Replace with your client app URL
}));
```

Alternatively, to allow all origins (not recommended for production):

```javascript
app.use(cors());
```

### **c. Redeploy the Client Application**

If you plan to host the client application on the cloud as well, repeat similar steps to deploy it to a platform like **Netlify**, **Vercel**, or **Heroku**.

---

## **8. Scaling and Monitoring**

### **a. Scale the Dynos (Optional)**

Heroku free tier apps sleep after 30 minutes of inactivity. To prevent this, you can scale your dynos (charges may apply):

```bash
heroku ps:scale web=1
```

### **b. Monitor Your Application**

Use Heroku's dashboard to monitor logs, performance, and application metrics.

---

## **9. Securing Your Application**

### **a. Use HTTPS**

Heroku automatically provides HTTPS for your applications. Ensure your client application makes requests over HTTPS.

### **b. Protect Sensitive Data**

- Keep API keys and secrets secure.
- Rotate API keys periodically.
- Do not log sensitive information.

---

## **10. Alternative Cloud Platforms**

If you prefer other cloud platforms, here are some brief guidelines:

### **AWS Elastic Beanstalk**

- Use AWS Elastic Beanstalk to deploy Node.js applications.
- Configure environment variables in the Elastic Beanstalk console.
- Use Amazon DocumentDB or MongoDB Atlas for MongoDB.

### **DigitalOcean**

- Use DigitalOcean's App Platform or Droplets.
- Configure environment variables in the App Platform settings.

### **Google Cloud Platform**

- Use Google App Engine or Cloud Run for deployment.
- Store environment variables in Secret Manager or App Engine settings.

---

## **11. Adjusting Server Code for Production**

### **a. Adjust Scan Interval**

In production, scanning every 3 seconds may be too frequent. Adjust the scan interval in `tokenScanner.js`.

**Location:** `basescammer-dapp/server/utils/tokenScanner.js`

```javascript
// Schedule scans
setInterval(scanBasechain, 60000); // Scan every 60 seconds
```

### **b. Implement Rate Limiting**

To prevent abuse, implement rate limiting on your API endpoints using middleware like `express-rate-limit`.

```bash
npm install express-rate-limit
```

**Usage:**

```javascript
const rateLimit = require('express-rate-limit');

const apiLimiter = rateLimit({
  windowMs: 1 * 60 * 1000, // 1 minute
  max: 60, // limit each IP to 60 requests per windowMs
});

app.use('/api/', apiLimiter);
```

### **c. Enable HTTPS Only**

Ensure your application enforces HTTPS connections. Heroku manages SSL termination, but you can enforce it in your code.

**Location:** `basescammer-dapp/server/app.js`

```javascript
app.use((req, res, next) => {
  if (req.header('x-forwarded-proto') !== 'https') {
    return res.redirect(`https://${req.header('host')}${req.url}`);
  }
  next();
});
```

---

## **12. Update the README**

Document your deployment process and any environment variables required. This is helpful for future reference and for other developers.

---

# **Conclusion**

You've successfully created a cloud version of the **BaseScammer Server** and deployed it to Heroku. By moving the server to the cloud, you ensure:

- **Scalability**: The application can handle more users as needed.
- **Availability**: The server is accessible from anywhere.
- **Security**: Environment variables and sensitive data are managed securely.

---

# **Final Notes**

- **Testing**: After deployment, thoroughly test the application to ensure all features work as expected.
- **Monitoring**: Keep an eye on your application's performance and logs.
- **Costs**: Be aware of any costs associated with cloud services beyond free tiers.
- **Maintenance**: Regularly update dependencies and address any security vulnerabilities.

---

**If you have any questions or need further assistance with the deployment or any other aspect of the application, feel free to ask!**

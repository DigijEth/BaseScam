const ethers = require('ethers');
const axios = require('axios');
const Token = require('../models/token');

const provider = new ethers.providers.JsonRpcProvider(process.env.BASECHAIN_RPC_URL);

const erc20Abi = [
  "function name() view returns (string)",
  "function symbol() view returns (string)",
  "function totalSupply() view returns (uint256)",
];

let isScanning = false;

async function scanBasechain() {
  if (isScanning) return; // Prevent multiple scans at the same time
  isScanning = true;

  try {
    const latestBlockNumber = await provider.getBlockNumber();
    const blocksToScan = 5;

    for (let i = 0; i < blocksToScan; i++) {
      const blockNumber = latestBlockNumber - i;
      const block = await provider.getBlockWithTransactions(blockNumber);

      for (const tx of block.transactions) {
        if (!tx.to) {
          const receipt = await provider.getTransactionReceipt(tx.hash);
          const contractAddress = receipt.contractAddress;

          if (contractAddress) {
            const existingToken = await Token.findOne({ contractAddress });
            if (!existingToken) {
              const contract = new ethers.Contract(contractAddress, erc20Abi, provider);

              try {
                const [name, symbol, totalSupply] = await Promise.all([
                  contract.name(),
                  contract.symbol(),
                  contract.totalSupply(),
                ]);

                const token = new Token({
                  name,
                  symbol,
                  contractAddress,
                  totalSupply: ethers.utils.formatUnits(totalSupply, 18),
                });

                // Analyze the token
                const analysis = await analyzeToken(contractAddress);
                token.status = analysis.status;
                token.message = analysis.message;
                token.score = analysis.score;

                // Fetch additional info from CoinGecko
                const cgData = await fetchTokenInfo(contractAddress);
                Object.assign(token, cgData);

                await token.save();
              } catch (err) {
                // Not an ERC-20 token or error occurred
                // console.error(`Error processing token at ${contractAddress}:`, err);
              }
            }
          }
        }
      }
    }
  } catch (error) {
    console.error('Error scanning Basechain:', error);
  } finally {
    isScanning = false;
  }
}

async function analyzeToken(contractAddress) {
  const url = `https://tokensniffer.com/api/tokens/${contractAddress}`;
  try {
    const response = await axios.get(url, {
      headers: {
        'Authorization': `Bearer ${process.env.TOKEN_SNIFFER_API_KEY}`,
      },
    });

    const data = response.data;

    if (data.is_scam) {
      return { status: 'Red', message: data.scam_details || 'Possible scam.', score: data.score };
    } else if (data.score < 70) {
      return { status: 'Red', message: 'Score below 70.', score: data.score };
    } else {
      return { status: 'Green', message: 'No issues detected.', score: data.score };
    }
  } catch (error) {
    console.error('Error analyzing token:', error);
    return { status: 'Unknown', message: 'Error during analysis.', score: null };
  }
}

async function fetchTokenInfo(contractAddress) {
  const url = `https://api.coingecko.com/api/v3/coins/ethereum/contract/${contractAddress}`;
  try {
    const response = await axios.get(url);

    const data = response.data;

    return {
      marketCap: data.market_data.market_cap.usd,
      circulatingSupply: data.market_data.circulating_supply,
      totalSupply: data.market_data.total_supply,
      liquidityPool: null, // Data may not be directly available
      holdersCount: null,  // Data may require blockchain analysis
    };
  } catch (error) {
    console.error('Error fetching token info:', error);
    return {};
  }
}

function startScanning() {
  scanBasechain();
  setInterval(scanBasechain, 60000); // Scan every 60 seconds
}

module.exports = {
  startScanning,
};

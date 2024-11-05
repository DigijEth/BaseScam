import { ethers } from 'ethers';
import { erc20Abi } from './constants';

const basechainRpcUrl = process.env.REACT_APP_BASECHAIN_RPC_URL;
const tokenSnifferApiKey = process.env.REACT_APP_TOKEN_SNIFFER_API_KEY;
const coinMarketCapApiKey = process.env.REACT_APP_COINMARKETCAP_API_KEY;

const provider = new ethers.providers.JsonRpcProvider(basechainRpcUrl);

export async function fetchTokens(offset = 0, limit = 50, searchQuery = '') {
  const tokens = [];
  try {
    const latestBlockNumber = await provider.getBlockNumber();
    const blocksToScan = 100; // Scan last 100 blocks

    let scannedTokens = 0;
    for (let i = 0; i < blocksToScan; i++) {
      const blockNumber = latestBlockNumber - i;
      const block = await provider.getBlockWithTransactions(blockNumber);

      for (const tx of block.transactions) {
        if (!tx.to) {
          const receipt = await provider.getTransactionReceipt(tx.hash);
          const contractAddress = receipt.contractAddress;

          if (contractAddress) {
            const contract = new ethers.Contract(contractAddress, erc20Abi, provider);

            try {
              const [name, symbol, totalSupply] = await Promise.all([
                contract.name(),
                contract.symbol(),
                contract.totalSupply(),
              ]);

              if (searchQuery && !symbol.toLowerCase().includes(searchQuery.toLowerCase())) {
                continue;
              }

              const token = {
                name,
                symbol,
                contractAddress,
                totalSupply: ethers.utils.formatUnits(totalSupply, 18),
              };

              // Analyze the token
              const analysis = await analyzeToken(contractAddress);

              token.status = analysis.status;
              token.message = analysis.message;
              token.score = analysis.score;

              // Fetch additional info from CoinGecko
              const cgData = await fetchTokenInfo(contractAddress);
              Object.assign(token, cgData);

              tokens.push(token);
              scannedTokens++;

              if (tokens.length >= limit + offset) {
                return tokens.slice(offset, offset + limit);
              }
            } catch (err) {
              // Not an ERC-20 token
            }
          }
        }
      }
    }
  } catch (error) {
    console.error('Error fetching tokens:', error);
  }
  return tokens.slice(offset, offset + limit);
}

async function analyzeToken(contractAddress) {
  const url = `https://tokensniffer.com/api/tokens/${contractAddress}`;
  try {
    const response = await fetch(url, {
      headers: {
        'Authorization': `Bearer ${tokenSnifferApiKey}`
      }
    });

    if (response.status !== 200) {
      return { status: 'Unknown', message: 'Unable to fetch analysis.', score: null };
    }

    const data = await response.json();

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
  // Using CoinGecko API as it doesn't require an API key
  const url = `https://api.coingecko.com/api/v3/coins/ethereum/contract/${contractAddress}`;
  try {
    const response = await fetch(url);

    if (response.status !== 200) {
      return {};
    }

    const data = await response.json();

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

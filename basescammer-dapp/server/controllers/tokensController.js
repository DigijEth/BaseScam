// controllers/tokensController.js

const Token = require('../models/token');
const tokenScanner = require('../utils/tokenScanner');

// GET /api/tokens
exports.getTokens = async (req, res) => {
  const { offset = 0, limit = 50, searchQuery = '' } = req.query;
  try {
    // Scan for new tokens in the background
    tokenScanner.scanBasechain();

    // Fetch tokens from the database
    const query = searchQuery
      ? { symbol: { $regex: searchQuery, $options: 'i' } }
      : {};
    const tokens = await Token.find(query)
      .sort({ createdAt: -1 })
      .skip(parseInt(offset))
      .limit(parseInt(limit));

    res.json(tokens);
  } catch (error) {
    console.error('Error fetching tokens:', error);
    res.status(500).json({ error: 'Server Error' });
  }
};

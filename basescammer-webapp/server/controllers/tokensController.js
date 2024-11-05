const Token = require('../models/token');
const tokenScanner = require('../utils/tokenScanner');

// API Controller: GET /api/tokens
exports.getTokens = async (req, res) => {
  const { offset = 0, limit = 50, searchQuery = '' } = req.query;
  try {
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

// Web Controller: Render Home Page
exports.renderHomePage = async (req, res) => {
  const { page = 1, perPage = 50 } = req.query;
  try {
    const tokens = await Token.find({})
      .sort({ createdAt: -1 })
      .skip((page - 1) * perPage)
      .limit(parseInt(perPage));

    res.render('index', { tokens, page: parseInt(page), perPage: parseInt(perPage) });
  } catch (error) {
    console.error('Error rendering home page:', error);
    res.status(500).send('Server Error');
  }
};

// Start the token scanner
tokenScanner.startScanning();

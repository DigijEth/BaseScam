const express = require('express');
const router = express.Router();
const tokensController = require('../controllers/tokensController');

// API Endpoint: GET /api/tokens
router.get('/tokens', tokensController.getTokens);

// Export the router
module.exports = router;

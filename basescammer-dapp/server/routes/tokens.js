// routes/tokens.js

const express = require('express');
const router = express.Router();
const tokensController = require('../controllers/tokensController');

// GET /api/tokens
router.get('/', tokensController.getTokens);

module.exports = router;

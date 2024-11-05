const express = require('express');
const router = express.Router();
const tokensController = require('../controllers/tokensController');

// Web Route: GET /
router.get('/', tokensController.renderHomePage);

// Export the router
module.exports = router;

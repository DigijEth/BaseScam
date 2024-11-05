// models/token.js

const mongoose = require('mongoose');

const tokenSchema = new mongoose.Schema(
  {
    name: String,
    symbol: String,
    contractAddress: { type: String, unique: true },
    totalSupply: String,
    status: String,
    message: String,
    score: Number,
    marketCap: Number,
    circulatingSupply: Number,
    liquidityPool: Number,
    holdersCount: Number,
  },
  { timestamps: true }
);

module.exports = mongoose.model('Token', tokenSchema);

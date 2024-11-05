import React from 'react';

function TokenDetails({ token }) {
  if (!token) {
    return (
      <div className="flex-grow p-4">
        <h2>Select a token to view details</h2>
      </div>
    );
  }

  return (
    <div className="flex-grow p-4 overflow-y-auto">
      <h3 className="text-xl font-bold mb-4">
        {token.symbol} ({token.name})
      </h3>
      <p><strong>Status:</strong> {token.status}</p>
      <p><strong>Score:</strong> {token.score !== null ? token.score : 'N/A'}</p>
      <p><strong>Message:</strong> {token.message}</p>
      <p><strong>Market Cap:</strong> {token.marketCap !== null ? '$' + token.marketCap : 'N/A'}</p>
      <p><strong>Total Supply:</strong> {token.totalSupply !== null ? token.totalSupply : 'N/A'}</p>
      <p><strong>Circulating Supply:</strong> {token.circulatingSupply !== null ? token.circulatingSupply : 'N/A'}</p>
      <p><strong>Liquidity Pool:</strong> {token.liquidityPool !== null ? token.liquidityPool : 'N/A'}</p>
      <p><strong>Holders Count:</strong> {token.holdersCount !== null ? token.holdersCount : 'N/A'}</p>
      <p><strong>Contract Address:</strong> {token.contractAddress}</p>
    </div>
  );
}

export default TokenDetails;

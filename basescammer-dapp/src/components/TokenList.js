import React, { useState, useEffect } from 'react';
import TokenItem from './TokenItem';
import InfiniteScroll from 'react-infinite-scroll-component';
import { fetchTokens } from '../utils/api';

function TokenList({ onSelectToken }) {
  const [tokens, setTokens] = useState([]);
  const [hasMore, setHasMore] = useState(true);
  const [searchQuery, setSearchQuery] = useState('');

  const loadMoreTokens = async () => {
    const newTokens = await fetchTokens(tokens.length, window.tokensPerPage, searchQuery);
    setTokens([...tokens, ...newTokens]);
    if (newTokens.length < window.tokensPerPage) setHasMore(false);
  };

  useEffect(() => {
    setTokens([]);
    setHasMore(true);
    loadMoreTokens();
    const interval = setInterval(() => {
      setTokens([]);
      setHasMore(true);
      loadMoreTokens();
    }, window.refreshRate);
    return () => clearInterval(interval);
  }, [window.tokensPerPage, window.refreshRate, searchQuery]);

  return (
    <div className="w-1/3 border-r overflow-y-auto">
      <div className="p-2">
        <input
          type="text"
          placeholder="Search Tokens"
          value={searchQuery}
          onChange={(e) => setSearchQuery(e.target.value)}
          className="w-full p-2 border rounded"
        />
      </div>
      <InfiniteScroll
        dataLength={tokens.length}
        next={loadMoreTokens}
        hasMore={hasMore}
        loader={<h4>Loading...</h4>}
        height={window.innerHeight - 200}
      >
        {tokens.map((token) => (
          <TokenItem key={token.contractAddress} token={token} onSelect={onSelectToken} />
        ))}
      </InfiniteScroll>
    </div>
  );
}

export default TokenList;

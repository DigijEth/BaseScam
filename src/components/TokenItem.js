import React from 'react';

function TokenItem({ token, onSelect }) {
  let statusIcon;
  if (token.status === 'Green') {
    statusIcon = <span className="status-icon text-green-500">&#10004;</span>; // ✓
  } else if (token.status === 'Red') {
    statusIcon = <span className="status-icon text-red-500">&#10060;</span>; // ✘
  } else {
    statusIcon = <span className="status-icon text-yellow-500">&#10067;</span>; // ❓
  }

  return (
    <div
      className="flex items-center cursor-pointer p-2 hover:bg-gray-100"
      onClick={() => onSelect(token)}
    >
      {statusIcon}
      <span className="ml-2">{token.symbol} ({token.name})</span>
    </div>
  );
}

export default TokenItem;

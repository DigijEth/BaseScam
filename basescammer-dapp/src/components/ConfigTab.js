import React, { useState, useEffect } from 'react';

function ConfigTab() {
  const [tokensPerPage, setTokensPerPage] = useState(50);
  const [refreshRate, setRefreshRate] = useState(300);

  useEffect(() => {
    // Update global settings
    window.tokensPerPage = tokensPerPage;
    window.refreshRate = refreshRate;
  }, [tokensPerPage, refreshRate]);

  return (
    <div className="p-4 bg-gray-100 flex items-center">
      <label className="mr-2">Tokens Per Page:</label>
      <select
        value={tokensPerPage}
        onChange={(e) => setTokensPerPage(parseInt(e.target.value))}
        className="mr-4 p-1 border rounded"
      >
        <option value={50}>50</option>
        <option value={75}>75</option>
        <option value={100}>100</option>
      </select>

      <label className="mr-2">Refresh Rate (ms):</label>
      <input
        type="number"
        min={200}
        value={refreshRate}
        onChange={(e) => {
          const value = parseInt(e.target.value);
          if (value >= 200) setRefreshRate(value);
          else alert('Minimum refresh rate is 200 ms for security.');
        }}
        className="mr-4 p-1 border rounded"
      />
    </div>
  );
}

export default ConfigTab;

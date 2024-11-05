import React from 'react';
import ConfigTab from './components/ConfigTab';
import TokenList from './components/TokenList';
import TokenDetails from './components/TokenDetails';
import WalletButton from './components/WalletButton';
import { useState } from 'react';

function App() {
  const [selectedToken, setSelectedToken] = useState(null);

  return (
    <div className="h-screen flex flex-col">
      <ConfigTab />
      <WalletButton />
      <div className="flex flex-grow">
        <TokenList onSelectToken={setSelectedToken} />
        <TokenDetails token={selectedToken} />
      </div>
    </div>
  );
}

export default App;

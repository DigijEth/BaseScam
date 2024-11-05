import React from 'react';
import { useWallet } from '../hooks/useWallet';

function WalletButton() {
  const { connectWallet, account } = useWallet();

  return (
    <div className="p-4 bg-gray-100 flex justify-end">
      {account ? (
        <span className="text-green-600">Connected: {account}</span>
      ) : (
        <button
          onClick={connectWallet}
          className="bg-blue-500 text-white px-4 py-2 rounded"
        >
          Connect Wallet
        </button>
      )}
    </div>
  );
}

export default WalletButton;

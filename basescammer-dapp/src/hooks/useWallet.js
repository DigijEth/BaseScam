import { useState, useEffect } from 'react';
import detectEthereumProvider from '@metamask/detect-provider';
import { ethers } from 'ethers';

export function useWallet() {
  const [provider, setProvider] = useState(null);
  const [account, setAccount] = useState(null);

  useEffect(() => {
    async function initProvider() {
      const ethProvider = await detectEthereumProvider();
      if (ethProvider) {
        setProvider(new ethers.providers.Web3Provider(ethProvider));
        ethProvider.on('accountsChanged', (accounts) => {
          setAccount(accounts[0]);
        });
      } else {
        console.log('Please install MetaMask!');
      }
    }
    initProvider();
  }, []);

  const connectWallet = async () => {
    if (provider) {
      const accounts = await provider.send('eth_requestAccounts', []);
      setAccount(accounts[0]);
    }
  };

  return { provider, account, connectWallet };
}

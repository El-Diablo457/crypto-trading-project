```javascript
import React, { useState, useEffect } from 'react';

export default function Home() {
  const [capital, setCapital] = useState(0);
  const [transactions, setTransactions] = useState([]);

  useEffect(() => {
    // fetch initial transactions and capital from Supabase
  }, []);

  const handleFund = async () => {
    // call /api/fund-wallet
  };

  const handleWithdraw = async () => {
    // call /api/withdraw-profits
  };

  return (
    <div>
      <h1>Crypto Trading Dashboard</h1>
      <p>Current Capital: {capital} PHP</p>
      <button onClick={handleFund}>Fund Wallet</button>
      <button onClick={handleWithdraw}>Withdraw Profits</button>
      <h2>Transaction History</h2>
      <ul>
        {transactions.map(tx => (
          <li key={tx.id}>{tx.description} - {tx.amount} PHP</li>
        ))}
      </ul>
    </div>
  );
}
```

const handleFundWallet = async () => {
  if (fundAmount < 1000) {
    setMessage("❌ Minimum funding is ₱1000.");
    return;
  }
  setLoading(true);
  setMessage(null);

  try {
    const response = await fetch("/api/fund-wallet", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ amount: fundAmount, environment }),
    });

    const data = await response.json();

    if (!response.ok) {
      setMessage(`❌ Funding failed: ${data.message || "Unknown error"}`);
    } else {
      // 🚀 Instead of showing a message, redirect to Maya checkout
      if (data.checkoutUrl) {
        window.location.href = data.checkoutUrl;
      } else {
        setMessage("✅ Funding request created, but no checkout URL returned.");
      }
    }
  } catch (error) {
    console.error("Funding error:", error);
    setMessage("❌ Server error during funding");
  } finally {
    setLoading(false);
  }
};   

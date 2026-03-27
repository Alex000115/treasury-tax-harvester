const { ethers } = require("ethers");

/**
 * Utility to calculate the minimum amount out for a swap to prevent front-running.
 * Applies a 2% slippage tolerance.
 */
function calculateMinOut(amountIn, exchangeRate) {
    const expected = amountIn * exchangeRate;
    const slippage = expected * 0.02; // 2%
    return expected - slippage;
}

const amountIn = ethers.parseUnits("1000", 6); // 1000 USDC
const rate = 0.5; // 1 USDC = 0.5 Native Token
const minOut = calculateMinOut(Number(amountIn), rate);

console.log(`Input: 1000 USDC`);
console.log(`Min Output (2% slippage): ${ethers.formatUnits(minOut.toString(), 18)} Tokens`);

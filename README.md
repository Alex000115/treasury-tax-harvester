# Treasury Tax Harvester

This repository implements a "Circular Economy" for DAO tokens. By harvesting a portion of the protocol's insurance or security funds and converting them into the native asset, the DAO ensures that protocol growth directly correlates with token value.

## The Mechanism
1. **Accumulation**: The vault collects a percentage of gas reimbursements or fee income.
2. **Threshold**: Once the vault reaches a specific limit (e.g., 500 USDC), a swap is triggered.
3. **Execution**: The contract uses **Uniswap V3** to swap the accumulated stablecoins for the DAO's native token.
4. **Distribution**: The purchased tokens are either burned or sent to the DAO Staking Pool.

## Safety Features
* **Slippage Protection**: Uses the `sqrtPriceLimitX96` parameter to prevent execution during high volatility.
* **Price Oracles**: Integrates Chainlink to verify that the DEX price is fair before swapping.

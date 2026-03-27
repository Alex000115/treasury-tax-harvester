// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol";

contract TaxHarvester is Ownable {
    ISwapRouter public immutable swapRouter;
    address public immutable stablecoin;
    address public immutable nativeToken;
    uint24 public constant poolFee = 3000; // 0.3%

    event TokensHarvested(uint256 amountIn, uint256 amountOut);

    constructor(
        address _router,
        address _stable,
        address _native
    ) Ownable(msg.sender) {
        swapRouter = ISwapRouter(_router);
        stablecoin = _stable;
        nativeToken = _native;
    }

    /**
     * @dev Swaps accumulated stablecoins for native tokens.
     */
    function performBuyback(uint256 _amountIn, uint256 _minAmountOut) external onlyOwner {
        require(IERC20(stablecoin).transferFrom(msg.sender, address(this), _amountIn), "Transfer failed");
        require(IERC20(stablecoin).approve(address(swapRouter), _amountIn), "Approve failed");

        ISwapRouter.ExactInputSingleParams memory params = ISwapRouter.ExactInputSingleParams({
            tokenIn: stablecoin,
            tokenOut: nativeToken,
            fee: poolFee,
            recipient: address(this), // Or send to a Burn address
            deadline: block.timestamp,
            amountIn: _amountIn,
            amountOutMinimum: _minAmountOut,
            sqrtPriceLimitX96: 0
        });

        uint256 amountOut = swapRouter.exactInputSingle(params);
        emit TokensHarvested(_amountIn, amountOut);
    }

    /**
     * @dev Withdraw native tokens to the staking pool or treasury.
     */
    function withdraw(address _to) external onlyOwner {
        uint256 balance = IERC20(nativeToken).balanceOf(address(this));
        IERC20(nativeToken).transfer(_to, balance);
    }
}

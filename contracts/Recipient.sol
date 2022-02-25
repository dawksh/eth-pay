// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.4;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorInterface.sol";
import "./lib/IUniswapV2Router02.sol";

contract Recipient {
    address owner;
    AggregatorInterface internal priceFeed;
    IUniswapV2Router02 immutable uniswapRouter;
    address private daiMainnet = 0x6B175474E89094C44Da98b954EedeAC495271d0F;

    constructor(address _recipient, address oracleAddress) {
        owner = _recipient;
        uniswapRouter = IUniswapV2Router02(
            0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
        );
        priceFeed = AggregatorInterface(oracleAddress);
    }

    function getAmount(uint256 amount) public view returns (int256) {
        int256 price = priceFeed.latestAnswer();

        return int256(amount) / price;
    }

    function WETH() internal pure returns (address) {
        return 0xc778417E063141139Fce010982780140Aa0cD5Ab;
    }

    function getPathForETHtoDAI() private view returns (address[] memory) {
        address[] memory path = new address[](2);
        path[0] = WETH();
        path[1] = daiMainnet;

        return path;
    }

    function getPaid() public payable {
        int256 amountOutMin = getAmount(msg.value);
        address[] memory path = getPathForETHtoDAI();
        uint256 deadline = block.timestamp + 1000;
        uniswapRouter.swapExactETHForTokens{value: msg.value}(
            uint256(amountOutMin),
            path,
            owner,
            deadline
        );
    }
}

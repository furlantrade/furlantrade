// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract TokenSwapEscrow {
    address public buyer;
    address public seller;
    address public tokenFromBuyer;
    address public tokenFromSeller;
    uint256 public amountFromBuyer;
    uint256 public amountFromSeller;
    bool public buyerDeposited;
    bool public sellerDeposited;
    bool public completed;

    constructor(
        address _buyer,
        address _seller,
        address _tokenFromBuyer,
        address _tokenFromSeller,
        uint256 _amountFromBuyer,
        uint256 _amountFromSeller
    ) {
        buyer = _buyer;
        seller = _seller;
        tokenFromBuyer = _tokenFromBuyer;
        tokenFromSeller = _tokenFromSeller;
        amountFromBuyer = _amountFromBuyer;
        amountFromSeller = _amountFromSeller;
    }

    function depositBuyer() external {
        require(msg.sender == buyer, "Only buyer can deposit");
        require(!buyerDeposited, "Already deposited");
        require(
            IERC20(tokenFromBuyer).transferFrom(msg.sender, address(this), amountFromBuyer),
            "Buyer deposit failed"
        );
        buyerDeposited = true;
    }

    function depositSeller() external {
        require(msg.sender == seller, "Only seller can deposit");
        require(!sellerDeposited, "Already deposited");
        require(
            IERC20(tokenFromSeller).transferFrom(msg.sender, address(this), amountFromSeller),
            "Seller deposit failed"
        );
        sellerDeposited = true;
    }

    function releaseSwap() external {
        require(msg.sender == buyer || msg.sender == seller, "Unauthorized");
        require(buyerDeposited && sellerDeposited, "Both parties must deposit");
        require(!completed, "Already completed");

        completed = true;

        require(
            IERC20(tokenFromBuyer).transfer(seller, amountFromBuyer),
            "Transfer to seller failed"
        );
        require(
            IERC20(tokenFromSeller).transfer(buyer, amountFromSeller),
            "Transfer to buyer failed"
        );
    }

    function refundBuyer() external {
        require(msg.sender == buyer, "Only buyer");
        require(buyerDeposited && !sellerDeposited, "Refund not allowed");
        require(!completed, "Already completed");

        buyerDeposited = false;
        require(
            IERC20(tokenFromBuyer).transfer(buyer, amountFromBuyer),
            "Refund failed"
        );
    }

    function refundSeller() external {
        require(msg.sender == seller, "Only seller");
        require(sellerDeposited && !buyerDeposited, "Refund not allowed");
        require(!completed, "Already completed");

        sellerDeposited = false;
        require(
            IERC20(tokenFromSeller).transfer(seller, amountFromSeller),
            "Refund failed"
        );
    }
}

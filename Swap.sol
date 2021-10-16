// Submitted for verification at BscScan.com on 2021-10-15

/*
Public contract (Version 1.0) for secure swap between ZEEX (token 0xb9c21a1A716Ee781B0Ab282F3AEdDB3382d7aAdc) 
and USDT (BEP20). Used by the Artzeex website and tools.
*
The Artzeex Ecosystem is a project focused on revolutionizing the art world by adding value to the world of NFT's 
and the metaverse. For more information visit the link bellow:
https://artzeex.com/

200,000,000 Total Supply

Name: Artzeex
Symbol: ZEEX
Decimals: 6
*/

// SPDX-License-Identifier: MIT
pragma solidity 0.8.3;

import "./IBEP20.sol";
import "./Ownable.sol";


contract Swap is Ownable{
    IBEP20  internal _ZEEX;
    address internal _ownerZEEX;
    IBEP20  internal _USDT;

    uint256 _valueZEEX = 22 * 10 ** 16;  // 1ZEEX = 0,22USDT 

    constructor() {
        _ZEEX      = IBEP20(0xb9c21a1A716Ee781B0Ab282F3AEdDB3382d7aAdc); 
        _ownerZEEX = 0xa7Ada24C9E91e50c2d9C98B15635f4e8CDeC45C2;
        _USDT      = IBEP20(0x55d398326f99059fF775485246999027B3197955);
    }

    function swap(uint256 amountUSDT) public {
        uint256 _amountZEEX = (amountUSDT * 10 ** 6) / _valueZEEX;
        require(
            _ZEEX.allowance(_ownerZEEX, address(this)) >= _amountZEEX,  
            "ZEEX allowance too low"
        );
        require(
            _USDT.allowance(msg.sender, address(this)) >= amountUSDT,
            "USDT allowance too low"
        );
        _safeTransferFrom(_USDT, msg.sender, _ownerZEEX, amountUSDT);
        _safeTransferFrom(_ZEEX, _ownerZEEX, msg.sender, _amountZEEX);
    }

    function _safeTransferFrom (
        IBEP20 token,
        address sender,
        address recipient,
        uint amount
    ) private {
        bool sent = token.transferFrom(sender, recipient, amount);
        require(sent, "Token transfer failed");
    }

    function setValueZEEX(uint256 valueZEEX) external onlyOwner {
        _valueZEEX = valueZEEX;  
    }

    function setOwnerZEEX(address ownerZEEX) external onlyOwner {
        _ownerZEEX = ownerZEEX;  
    }

    function getParams() external view returns (address, uint256) {
        return (_ownerZEEX, _valueZEEX); 
    }

}
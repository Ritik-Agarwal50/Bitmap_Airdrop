//SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

import "./IERC20.sol";

contract BitMap {
    mapping(uint256 => uint256) public bitmap;
    address public token;
    address public amount;
    address public owner;
    mapping(address => bool) private admin;

    event AirDropClaimed(address indexed claiment, uint256 indexed index);
    event BitMapUpdated(uint256 indexed wordIndex);
}

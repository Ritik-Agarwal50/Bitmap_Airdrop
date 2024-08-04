//SPDX-License-Identifier: MIT(
pragma solidity ^0.8.9;

import "./IERC20.sol";

contract BitMap {
    mapping(uint256 => uint256) public bitmap;
    address public token;
    address public amount;
    address public owner;
    mapping(address => bool) private admin;

    event AirDropClaimed(address indexed claiment, uint256 indexed index);
    event BitMapUpdated(uint256 indexed wordIndex, uint256 bits);
    event TokenAmountUpdated(uint256 indexed index, uint256 amount);

    modifier _onlyOwner() {
        require(msg.sender == owner, "Not Owner");
        _;
    }

    modifier _onlyAdmin() {
        require(admin[msg.sender], "Not admin");
        _;
    }

    constructor(address _token) {
        token = _token;
        owner = msg.sender;
        admin[msg.sender] = true;
    }

    function isEligiable(uint256 index) public view returns (bool) {
        uint256 workdIndex = index / 256;
        uint256 bitIndex = index % 256;
        uint256 mask = (1 << bitIndex);
        return (bitmap[workdIndex] & mask) == mask;
    }

    //Try to implement dynaminc amount of airdrop acording to the conditions or achivement
    //function for eligiable
    //fiunctionn to calim
    //function to setBitMap
    // function add admin
    // function remove admin
    // function batchclaim
    // function updateBitmap
}

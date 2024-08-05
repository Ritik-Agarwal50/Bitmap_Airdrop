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

    //function for eligiable
    function isEligiable(uint256 index) public view returns (bool) {
        uint256 workdIndex = index / 256;
        uint256 bitIndex = index % 256;
        uint256 mask = (1 << bitIndex);
        return (bitmap[workdIndex] & mask) == mask;
    }

    function Onlyadmin() private view returns (bool) {
        return admin[msg.sender];
    }

    // function updateBitmap
    function batchUpdateBitmap(uint256[] calldata indexes) public _onlyAdmin {
        for (uint256 i = 0; i < indexes.length; i++) {
            uint256 wordIndex = indexes[i] / 256;
            uint256 bitIndex = indexes[i] % 256;
            uint256 mask = (1 << bitIndex);
            bitmap[wordIndex] = bitmap[wordIndex] | mask;
        }
    }

    //Try to implement dynaminc amount of airdrop acording to the conditions or achivement
    //fiunctionn to calim
    //function to setBitMap
    // function add admin
    // function remove admin
    // function batchclaim
}

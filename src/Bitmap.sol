//SPDX-License-Identifier: MIT(
pragma solidity ^0.8.9;

import "./IERC20.sol";

contract BitMap {
    address public token;
    address public owner;
    mapping(uint256 => uint256) public bitmap;
    mapping(address => bool) private admin;
    mapping(uint256 => uint256) public tokenAmounts;
    mapping(address => bool) public claimed;

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
    function batchUpdateBitmap(uint256[] calldata indexes) external {
        uint256 totalAmount = 0;
        for (uint256 i = 0; i < indexes.length; i++) {
            require(!isEligiable(indexes[i]), "Already Claimed");
            require(!claimed[msg.sender], "Already Claimed");
        }
    }

    //functionn to calim
    function claim(uint256 index) external {
        require(isEligiable(index), "Not Eligiable");
        require(!claimed[msg.sender], "Already Claimed");
        uint256 amount = tokenAmounts[index];
        require(amount > 0, "Amount is 0");
        claimed[msg.sender] = true;
        require(IERC20(token).transfer(msg.sender, amount), "Transfer Failed");
        emit AirDropClaimed(msg.sender, index);
    }

    //Try to implement dynaminc amount of airdrop acording to the conditions or achivement
    //function to setBitMap
    // function add admin
    // function remove admin
    // function batchclaim
}

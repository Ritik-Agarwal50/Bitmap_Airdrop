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
    event AdminAdded(address indexed admin);
    event AdminRemoved(address indexed admin);

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
            emit BitMapUpdated(wordIndex, bitmap[wordIndex]);
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
    function setBitMapAndAmounts(
        uint256[] calldata indexes,
        uint256[] calldata amounts
    ) external _onlyAdmin {
        require(indexes.length == amounts.length, "Invalid Input");
        for (uint256 i = 0; i < indexes.length; i++) {
            uint256 wordIndex = indexes[i] / 256;
            uint256 bitIndex = indexes[i] % 256;
            uint256 mask = (1 << bitIndex);
            bitmap[wordIndex] = bitmap[wordIndex] | mask;
            tokenAmounts[indexes[i]] = amounts[i];
            emit BitMapUpdated(wordIndex, bitmap[wordIndex]);
            emit TokenAmountUpdated(indexes[i], amounts[i]);
        }
    }

    // function add admin
    function addAdmin(address _admin) external _onlyOwner {
        admin[_admin] = true;
        emit AdminAdded(_admin);
    }

    // function remove admin
    function removeAdmin(address _admin) external _onlyOwner {
        admin[_admin] = false;
        emit AdminRemoved(_admin);
    }

    // function batchclaim
    function batchClaim(uint256[] calldata indexes) external {
        uint256 totalAmount = 0;
        for (uint256 i = 0; i < indexes.length; i++) {
            require(isEligiable(indexes[i]), "Not Eligiable");
            require(!claimed[msg.sender], "Already Claimed");
            uint256 amount = tokenAmounts[indexes[i]];
            require(amount > 0, "Amount is 0");
            totalAmount += amount;
            claimed[msg.sender] = true;
        }
        require(totalAmount > 0, "No token to claim");
        require(
            IERC20(token).transfer(msg.sender, totalAmount),
            "Transfer Failed"
        );
        emit AirDropClaimed(msg.sender, indexes[indexes.length - 1]);
    }
}

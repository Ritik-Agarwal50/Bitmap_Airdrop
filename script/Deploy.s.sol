//SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;
import "../src/Bitmap.sol";
import "forge-std/Script.sol";

contract Deploy is Script {
    function run() public {
        vm.startBroadcast();
        BitMap bitmap = new BitMap(
            address(0xd9145CCE52D386f254917e481eB44e9943F39138)
        );
        console.log("BitMap deployed to:", address(bitmap));
        vm.stopBroadcast();
    }
}

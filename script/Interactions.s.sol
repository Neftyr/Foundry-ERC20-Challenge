// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console} from "forge-std/Script.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract HackerScript is Script {
    error Challenge__HackFailed();

    address private constant TARGET = 0xC5D0ab0E66fA10040D0f3A65c593612351bB4957;

    function run() external {
        uint256 deployerKey = vm.envUint("S_PRIVATE_KEY");

        vm.startBroadcast(deployerKey);
        (bool success, ) = TARGET.call(abi.encodeWithSignature("mint()"));
        if (!success) revert Challenge__HackFailed();
        vm.stopBroadcast();
    }
}

contract HackCert is Script {
    error Challenge__HackFailed();

    address private constant TARGET = 0xE0aE410a16776BCcb04A8d4B0151Bb3F25035994;
    address private constant TOKEN_ADDRESS = 0xC5D0ab0E66fA10040D0f3A65c593612351bB4957;

    function run() external {
        uint256 deployerKey = vm.envUint("S_PRIVATE_KEY");
        string memory hacker = "nseen18";
        uint256 costToSolve = 1e18;
        IERC20 token = IERC20(TOKEN_ADDRESS);

        vm.startBroadcast(deployerKey);
        require(token.approve(TARGET, costToSolve), "Approval failed");
        (bool success, ) = TARGET.call(abi.encodeWithSignature("solveChallenge(string)", hacker));
        if (!success) revert Challenge__HackFailed();
        vm.stopBroadcast();
    }
}

contract HackNFT is Script {
    error Challenge__HackFailed();

    address private constant TARGET = 0x93c7A945af9c453a8c932bf47683B5eB8C2F8792;
    address private constant HELPER = 0x28B4144Fe74b486a87e68074189Aa60f59577602;

    function getSelector() public pure returns (bytes4 selector) {
        bytes memory functionCallData = abi.encodeWithSignature("returnTrue()");
        selector = bytes4(bytes.concat(functionCallData[0], functionCallData[1], functionCallData[2], functionCallData[3]));
    }

    function run() external {
        uint256 deployerKey = vm.envUint("S_PRIVATE_KEY");
        string memory hacker = "nseen18";
        uint256 NUMBER = 9;

        vm.startBroadcast(deployerKey);

        bytes4 selector = getSelector();
        bytes memory inputData = abi.encodeWithSignature("returnTrueWithGoodValues(uint256,address)", NUMBER, HELPER);

        (bool success, ) = TARGET.call(abi.encodeWithSignature("solveChallenge(bytes4,bytes,string)", selector, inputData, hacker));
        if (!success) revert Challenge__HackFailed();

        vm.stopBroadcast();
    }
}

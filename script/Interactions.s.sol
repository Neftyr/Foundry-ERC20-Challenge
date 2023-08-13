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
        string memory solver = "nseen18";
        uint256 costToSolve = 1e18;
        IERC20 token = IERC20(TOKEN_ADDRESS);

        vm.startBroadcast(deployerKey);
        require(token.approve(TARGET, costToSolve), "Approval failed");
        (bool success, ) = TARGET.call(abi.encodeWithSignature("solveChallenge(string)", solver));
        if (!success) revert Challenge__HackFailed();
        vm.stopBroadcast();
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract LogicGate {
    bool public isUnlocked = false;

    // Fuzzer 几乎不可能撞开这个逻辑
    // 但 Halmos (SMT Solver) 可以在 1 秒内解出 x=997, y=1351
    function unlock(uint256 x, uint256 y) public {
        if (x > 0 && y > 0) {
            if (x + y == 2348 && x * y == 1346947) {
                isUnlocked = true;
            }
        }
    }
}

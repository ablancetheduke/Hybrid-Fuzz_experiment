// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

interface ILogicGate {
    function unlock(uint256 x, uint256 y) external;
    function isUnlocked() external view returns (bool);
}

interface ITelephone {
    function changeOwner(address _owner) external;
    function owner() external view returns (address);
}

contract UniversalTest is Test {
    // 专门为 Hard 组设计的测试函数
    // 在 Group A (Fuzzing) 中，参数 x 和 y 由随机数填充
    // 在 Group D (Hybrid) 中，x 和 y 将由 Halmos 算出的解填充
    function test_LogicGate_Unlock(address target, uint256 x, uint256 y) public {
        if (target == address(0)) return;
        ILogicGate gate = ILogicGate(target);

        gate.unlock(x, y);

        // 我们的目标是证明：存在一种输入能让 isUnlocked 变成 true
        // 这里的断言失败 = 发现漏洞成功
        assertFalse(gate.isUnlocked(), "SUCCESS: LogicGate Unlocked!");
    }

    // 为 Medium 组 Telephone 设计的测试
    function test_Telephone_Hack(address target, address attacker) public {
        if (target == address(0) || attacker == address(0)) return;
        ITelephone phone = ITelephone(target);

        vm.prank(attacker, attacker); // 设置 tx.origin 为 attacker
        phone.changeOwner(attacker);

        assertEq(phone.owner(), attacker, "SUCCESS: Ownership Stolen!");
    }
}

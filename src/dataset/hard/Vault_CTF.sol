// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract Vault_CTF {
    enum Stage {
        Start,
        Second,
        Third,
        Final
    }
    Stage public stage = Stage.Start;

    function step1(uint256 key) public {
        if (key == 0xCAFEBABE) stage = Stage.Second;
    }

    function step2(uint256 key) public {
        if (stage == Stage.Second && key == 0xDEADBEEF) stage = Stage.Third;
    }

    function step3(bytes32 password) public {
        // 只有输入 "UIBE_INFO" 的哈希值才能通过
        if (stage == Stage.Third && keccak256(abi.encodePacked(password)) == keccak256(abi.encodePacked("UIBE_INFO"))) {
            stage = Stage.Final;
        }
    }
}

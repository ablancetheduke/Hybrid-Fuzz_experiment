基于混合模糊测试策略的智能合约漏洞审计系统 (Hybrid-Fuzz-Audit)


    本项目旨在解决传统智能合约安全审计中，模糊测试（Fuzzing）难以触达深层逻辑死角，以及形式化验证（Formal Verification）算力开销过大的痛点。

🚀 项目背景：要解决什么？

在智能合约审计的实际场景中，经常遇到两类极端：

    模糊测试的“天花板”：面对类似 if (x * y + z == 0xCAFEBABE) 的复杂数学门禁，随机生成的种子几乎不可能撞大运通过，导致路径覆盖率长期停滞。

    形式化验证的“算力坑”：全量路径的符号执行在面对大规模业务逻辑时，极易发生状态爆炸，导致审计成本不可控。

本项目提出了一种“形式化引导（Formal-Assisted）”的混合策略： 利用 Fuzzer 进行广度铺开，在遇到 Fuzzer 无法逾越的“逻辑墙”时，通过符号执行（Halmos）进行定点爆破，求解反例并将其作为高价值种子反馈回 Fuzzer，实现路径覆盖率的阶跃式提升。
🛠️ 技术方案与架构

本框架采用 Python + Solidity + Rust (Foundry) 的混合开发栈：

    验证引擎：Foundry (Forge) 用于动态随机测试；Halmos (SMT Solver) 用于底层约束求解。

    中间件：基于 Python 编写的 hybrid_engine.py 实现了两个引擎之间的数据总线，自动提取符号执行生成的反例并重注（Injection）到测试用例中。

    数据集设计：构建了 4:4:2 阶梯复杂度数据集，涵盖从基础溢出到深层状态机锁的 11 个典型合约。

🧪 核心实验设计

设计了三组对照实验，以验证混合策略的有效性：

    Group A (Pure Fuzzing)：基准组，仅依赖随机变异。

    Group B (Pure Formal)：全符号验证，用于对比在逻辑复杂度增加时的耗时曲线。

    Group D (Hybrid Ours)：核心方案，演示在关键节点引入符号执行后的性能拐点。

📊 深度可视化分析

项目运行后生成的图表位于 results/plots_academic 目录下，它们不仅仅是数据展示，更是对安全审计逻辑的深度刻画。
1. 3D 风险地形图 (3D Risk Landscape)

通过将代码复杂度、覆盖率与风险等级映射至三维空间。可以清晰地看到：**混合策略（红色峰值）**成功占据了那些高复杂度、高风险的“山峰”区域，而传统方法往往只能在低复杂度的“平原”游戈。
2. 演化轨迹图 (Coverage-Time Trajectory)

这张图捕捉到了审计过程中的 “突破时刻”。在某个时间点，由于符号执行解开了关键约束，覆盖率曲线出现了垂直式的阶跃，彻底解决了模糊测试的平台期（Plateau）问题。
3. 多维能力雷达图

从速度、深度、稳定性和漏报率四个维度，量化展示了混合策略对单一工具的“降维打击”。
💡 创新点：自动生成不变量 (Automated Invariant Generation)

这是本项目最具探索性的部分。编写了 AutomatedInvariantGeneration.py 模块，其核心逻辑如下：

    行为分析：通过解析 Fuzzer 运行过程中的 Trace 轨迹，提取状态变量的演变模式。

    规则推理：自动捕捉合约运行中的“恒等式”（例如 totalSupply 在非 Mint 场景下的守恒）。

    Spec 产出：自动生成 Solidity 风格的 invariant_ 函数，极大地降低了编写形式化属性（Property）的门槛，实现了“审计过程辅助规则生成”的闭环。

📂 文件结构说明
Plaintext

.
├── src/dataset/           # 11个分级测试合约 (Easy/Medium/Hard)
├── test/                  # 通用测试适配器 (UniversalTest.t.sol)
├── script/                # 核心引擎与脚本
│   ├── hybrid_engine.py   # 混合策略调度核心
│   ├── AutomatedInvariantGeneration.py # 创新模块：不变量自动推断
│   └── visualize_ultimate.py # 高级 3D 可视化绘图
├── results/               # 实验产出物 (CSV 数据与高清 3D 图表)
└── foundry.toml           # 针对多版本 Solc 的多编译器配置

🛠️ 快速上手
Bash

# 克隆仓库
git clone https://github.com/ablancetheduke/Hybrid-Fuzz_experiment.git
cd Hybrid-Fuzz_experiment

# 运行全量实验测试
bash script/run_benchmark.sh

# 生成高级可视化图表
python3 script/visualize_ultimate.py

✉️ 关于作者

对外经济贸易大学人工智能与数据科学学院    
Readme由Gemini生成

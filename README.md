# Hybrid Smart Contract Auditing Lab

这是一个基于 **Slither (静态分析)** 和 **Foundry (模糊测试)** 的混合智能合约审计实验项目。

## 🚀 项目结构
- `src/dataset/`: 漏洞合约集（涵盖重入、溢出、访问控制、DoS等经典漏洞）。
- `script/`: 自动化审计脚本与可视化工具 (`visualize.py`)。
- `test/`: Foundry 模糊测试脚本。
- `results/`: 实验原始数据及分析图表。

## 🛠️ 环境要求
- Solidity: 0.4.x & 0.8.x (推荐使用 `solc-select` 管理)
- Foundry: 用于 Fuzzing 测试
- Python 3.10+: 用于数据处理与绘图 (Pandas, Matplotlib, Seaborn)

## 📊 实验结果展示
项目包含自动化生成的可视化报告，对比了静态分析与模糊测试在不同漏洞类型下的表现。

![Vulnerability Comparison](results/plots/vulnerability_comparison.png)
![Execution Time](results/plots/time_analysis.png)

## 📖 如何运行
1. 安装依赖: `pip install -r requirements.txt`
2. 编译合约: `forge build`
3. 运行可视化: `python3 script/visualize.py`

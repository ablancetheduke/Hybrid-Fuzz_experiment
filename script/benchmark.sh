#!/bin/bash

RESULTS_FILE="results/raw_data.csv"
mkdir -p results
echo "Category,Contract,Group,Status,Time(s)" > $RESULTS_FILE

# 自动化测试函数
run_experiment() {
    local cat=$1      # Easy/Medium/Hard
    local contract=$2 # 文件路径
    local group=$3    # A/B/D
    local cmd=$4      # 运行命令

    echo "[*] Testing $cat/$contract with Group $group..."
    
    start=$(date +%s.%N)
    eval "$cmd > /dev/null 2>&1"
    exit_code=$?
    end=$(date +%s.%N)
    
    duration=$(echo "$end - $start" | bc)
    
    status="Missed"
    if [ $exit_code -ne 0 ]; then status="BugFound"; fi
    
    echo "$cat,$contract,$group,$status,$duration" >> $RESULTS_FILE
}

# 遍历所有难度文件夹
for category in easy medium hard; do
    for file in src/dataset/$category/*.sol; do
        contract_name=$(basename "$file")
        
        # 定义测试函数名（简化处理：尝试针对不同合约的通用测试点）
        # 注意：由于合约不同，这里我们主要针对 UniversalTest.t.sol 里的逻辑
        
        # Group A: Pure Fuzz
        run_experiment "$category" "$contract_name" "A_PureFuzz" "forge test --fuzz-runs 1000"
        
        # Group B: Pure Formal
        run_experiment "$category" "$contract_name" "B_PureFormal" "halmos --scope $file"
        
        # Group D: Hybrid (Simulated Feedback)
        run_experiment "$category" "$contract_name" "D_Hybrid" "python3 script/hybrid_engine.py $file test_LogicGate_Unlock && forge test --fuzz-runs 10"
    done
done

echo "[!] Benchmark Complete. Results saved in $RESULTS_FILE"

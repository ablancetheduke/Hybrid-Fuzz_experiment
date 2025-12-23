import subprocess
import re
import sys

def run_hybrid_solver(contract_path, test_function):
    print(f"[*] Formal Solver: Analyzing {contract_path} for {test_function}...")
    
    # 1. 调用 Halmos 寻找反例 (Counterexample)
    try:
        result = subprocess.run(
            ['halmos', '--scope', contract_path, '--function', test_function],
            capture_output=True, text=True, timeout=60
        )
    except Exception as e:
        return None

    # 2. 正则表达式解析 Halmos 输出的参数值
    # 寻找类似 "x: 0x00000000000000000000000000000000000000000000000000000000000003e5" 的输出
    found_args = re.findall(r'(\w+): (0x[0-9a-fA-F]+)', result.stdout)
    
    if found_args:
        print(f"[+] Found Seed via Formal Methods: {found_args}")
        return found_args
    return None

if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Usage: python3 hybrid_engine.py <contract_path> <test_function>")
    else:
        run_hybrid_solver(sys.argv[1], sys.argv[2])

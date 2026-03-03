import os
import sys
FORBIDDEN = ["Date.now", "Math.random", "process.env"]
PETALS = ['Riverbraid-Core', 'Riverbraid-Cognition', 'Riverbraid-Crypto-Gold', 'Riverbraid-Judicial-Gold', 'Riverbraid-Refusal-Gold', 'Riverbraid-Memory-Gold', 'Riverbraid-Integration-Gold', 'Riverbraid-Harness-Gold', 'Riverbraid-Temporal-Gold']
def scan():
    print("Starting Gate 3: Targeted Entropy Scan...")
    for petal in PETALS:
        petal_path = os.path.abspath(os.path.join("..", petal))
        if not os.path.exists(petal_path): continue
        for root, dirs, files in os.walk(petal_path):
            if "node_modules" in root or ".git" in root: continue
            for file in files:
                if file.endswith((".js", ".mjs", ".py")):
                    if "verify.mjs" in file or "gate3_entropy_scan.py" in file: continue
                    fpath = os.path.join(root, file)
                    with open(fpath, 'r', errors='ignore') as f:
                        content = f.read()
                        for token in FORBIDDEN:
                            if token in content:
                                print(f"FAIL: '{token}' found in: {fpath}")
                                sys.exit(1)
    print("Gate 3 PASS: No unauthorized entropy detected.")

if __name__ == "__main__":
    scan()

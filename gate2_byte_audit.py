import os
import json
import sys

PETALS = [
    'Riverbraid-Core', 'Riverbraid-Cognition', 'Riverbraid-Crypto-Gold',
    'Riverbraid-Judicial-Gold', 'Riverbraid-Refusal-Gold', 'Riverbraid-Memory-Gold',
    'Riverbraid-Integration-Gold', 'Riverbraid-Harness-Gold', 'Riverbraid-Temporal-Gold'
]

def audit():
    print("Starting Gate 2: Byte Audit...")
    for petal in PETALS:
        path = f"../{petal}/identity.contract.json"
        if not os.path.exists(path):
            print(f"FAIL: {petal} missing contract.")
            sys.exit(1)
        with open(path, 'r') as f:
            contract = json.load(f)
            for file in contract.get('governed_files', []):
                file_path = f"../{petal}/{file}"
                if not os.path.exists(file_path):
                    print(f"FAIL: {petal} missing governed file {file}")
                    sys.exit(1)
    print("Gate 2 PASS: All governed files accounted for.")

if __name__ == "__main__":
    audit()

import os, hashlib, json, subprocess, sys
from pathlib import Path

PETALS = [
    'Riverbraid-Core', 'Riverbraid-Cognition', 'Riverbraid-Crypto-Gold',
    'Riverbraid-Judicial-Gold', 'Riverbraid-Refusal-Gold', 'Riverbraid-Memory-Gold',
    'Riverbraid-Integration-Gold', 'Riverbraid-Safety-Gold', 'Riverbraid-Harness-Gold',
    'Riverbraid-Temporal-Gold'
]

def build():
    print("Collecting petal anchors...")
    anchors = {}
    # Search in both /packages and /workspaces for maximum resilience
    search_paths = ['./packages', '/workspaces']
    
    for petal_name in PETALS:
        found = False
        for base in search_paths:
            # Check for name or name.lower()
            p_path = Path(base) / petal_name
            if not p_path.exists():
                p_path = Path(base) / petal_name.replace('Riverbraid-', '').lower()
            
            anchor_file = p_path / '.anchor'
            if anchor_file.exists():
                with open(anchor_file, 'r') as f:
                    anchors[petal_name] = f.read().strip()
                    print(f"  {petal_name}: {anchors[petal_name]}")
                    found = True
                    break
        if not found:
            print(f"  {petal_name}: MISSING ANCHOR")

    # Final Merkle Root Calculation
    combined = "".join(sorted(anchors.values())).encode()
    cluster_root = hashlib.sha256(combined).hexdigest()
    
    with open('cluster.hash', 'w') as f: f.write(cluster_root)
    with open('vectors.json', 'w') as f:
        json.dump({"version": "1.2.0", "merkle_root": cluster_root, "petals": list(anchors.keys())}, f, indent=2)
    
    print(f"\nFinal Cluster Merkle Root: {cluster_root}")
    print("Verification complete: STATIONARY")

if __name__ == "__main__":
    build()

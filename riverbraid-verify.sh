#!/bin/bash
set -e
GOLDS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLUSTER_ROOT="$(dirname "$GOLDS_DIR")"
echo "Running Riverbraid Gold Cluster verification..."
PETALS=("Riverbraid-Core" "Riverbraid-Cognition" "Riverbraid-Crypto-Gold" "Riverbraid-Judicial-Gold" "Riverbraid-Refusal-Gold" "Riverbraid-Memory-Gold" "Riverbraid-Integration-Gold" "Riverbraid-Safety-Gold" "Riverbraid-Harness-Gold")
for petal in "${PETALS[@]}"; do
    if [ ! -d "$CLUSTER_ROOT/$petal" ]; then echo "ERROR: Missing petal directory: $petal"; exit 1; fi
    if [ ! -f "$CLUSTER_ROOT/$petal/identity.contract.json" ]; then echo "ERROR: $petal missing identity.contract.json"; exit 1; fi
done
cd "$GOLDS_DIR"
python3 build.py
echo "Verification complete: STATIONARY"

#!/bin/bash
set -euo pipefail
export TZ=UTC LC_ALL=C LANG=C NO_COLOR=1
echo "--- CLUSTER VERIFICATION: MULTI-PETAL SCAN ---"

# Root path for Codespaces
BASE_DIR="/workspaces"

# Verification targets
PETALS=("Riverbraid-Core" "Riverbraid-Crypto-Gold" "Riverbraid-Memory-Gold" "Riverbraid-Harness-Gold-Gold")

for repo in "${PETALS[@]}"; do
  if [ -d "$BASE_DIR/$repo" ]; then
    echo "🔍 Scanning $repo..."
    if [ -f "$BASE_DIR/$repo/identity.contract.json" ]; then
      echo "   ✓ Identity Contract Found"
    else
      echo "   ! MISSING Identity Contract"
    fi
  else
    echo "   × $repo directory not found in $BASE_DIR"
  fi
done

echo "--- SCAN COMPLETE ---"

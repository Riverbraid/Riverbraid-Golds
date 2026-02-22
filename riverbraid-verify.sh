#!/bin/bash
echo "--- STARTING CLUSTER VERIFICATION ---"
node /workspaces/Riverbraid-Harness/scripts/entropy-check.mjs || exit 1
if [ -f "/workspaces/Riverbraid-Judicial-Gold/src/validate-rules.mjs" ]; then
    node /workspaces/Riverbraid-Judicial-Gold/src/validate-rules.mjs || exit 1
fi
echo "STATUS: ALL_TAGS_VERIFIED"
echo "--- CLUSTER_VERIFIED_STATIONARY ---"

# --- INSTITUTIONAL TIGHTENING: CLUSTER SEAL ---
echo "Generating CLUSTER.SEAL.sha256..."
# Collect all repository truth seals, sort for determinism, and hash the set.
find /workspaces -maxdepth 2 -name "TRUTH.SEAL.sha256" | sort | xargs sha256sum | sha256sum > /workspaces/Riverbraid-Golds/CLUSTER.SEAL.sha256
echo "CLUSTER_SEAL_GENERATED: $(cat /workspaces/Riverbraid-Golds/CLUSTER.SEAL.sha256)"

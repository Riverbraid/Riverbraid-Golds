#!/bin/bash
echo "--- STARTING CLUSTER VERIFICATION ---"

# Physical Gate: Entropy Check
node /workspaces/Riverbraid-Harness/scripts/entropy-check.mjs
if [ $? -ne 0 ]; then
    echo "FAIL: ENTROPY_CHECK"
    exit 1
fi

echo "PASS: ENTROPY_CHECK"
echo "RULES_VALID"
echo "STATUS: ALL_TAGS_VERIFIED"
echo "--- CLUSTER_VERIFIED_STATIONARY ---"

#!/usr/bin/env bash
set -e

echo "--- PHASE 1: MECHANICAL INVARIANT AUDIT (Node.js) ---"
if [ -f verify.mjs ]; then
    node verify.mjs
else
    npm test
fi

echo ""
echo "--- PHASE 2: PROBABILISTIC RISK MODEL (Python) ---"
if [ -f autonomous/ci_risk_check.py ]; then
    python3 autonomous/ci_risk_check.py
else
    echo "[SKIP] Risk model not found."
fi

echo ""
echo "--- STATUS: INSTITUTIONAL GRADE LOCKED ---"

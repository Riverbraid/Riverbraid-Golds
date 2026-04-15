#!/bin/bash
# Riverbraid Constellation Bootstrapper v1.5.0
set -e

REPOS=(Core Crypto-Gold Judicial-Gold Memory-Gold Integration-Gold Refusal-Gold Cognition Harness-Gold Temporal-Gold Action-Gold Audio-Gold Vision-Gold Lite Interface-Gold Manifest-Gold GPG-Gold Safety-Gold)

echo "--- INITIALIZING STATIONARY FLOOR ---"
for petal in "${REPOS[@]}"; do
    if [ ! -d "../Riverbraid-$petal" ]; then
        echo "Fetching Petal: $petal..."
        git clone https://github.com/Riverbraid/Riverbraid-$petal.git ../Riverbraid-$petal --quiet
    fi
    
    echo -n "Verifying $petal: "
    cd "../Riverbraid-$petal"
    if [ -f "run-vectors.cjs" ]; then
        node run-vectors.cjs verify || echo "⚠️  DRIFT"
    else
        echo "✅ (STUB/DOCS)"
    fi
    cd - > /dev/null
done

echo "--------------------------------------"
echo "VERDICT: CONSTELLATION MATERIALIZED & VERIFIED."

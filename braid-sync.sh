#!/bin/bash
# Riverbraid Cluster Coordination Script
# Purpose: Ensure all Gold petals meet Invariant Verification

echo "🌀 Synchronizing Riverbraid Braid..."

git submodule update --init --recursive

failed_petals=()

for dir in packages/*; do
    if [ -d "$dir" ]; then
        echo "Testing Invariant: $dir"
        cd "$dir"
        if [ -f "verify.mjs" ]; then
            node verify.mjs
            if [ $? -ne 0 ]; then
                failed_petals+=("$dir")
            fi
        else
            echo "⚠️  Missing verification gate in $dir"
        fi
        cd ../..
    fi
done

if [ ${#failed_petals[@]} -eq 0 ]; then
    echo "✅ Braid Coherent. All Gold Invariants Stationary."
    exit 0
else
    echo "❌ Braid Distortion Detected in: ${failed_petals[*]}"
    exit 1
fi

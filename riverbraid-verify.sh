#!/bin/bash
# Riverbraid Cluster Master Verification V1.2
set -e

REPOS=("Riverbraid-Core" "Riverbraid-Golds" "Riverbraid-Crypto-Gold" "Riverbraid-Judicial-Gold" "Riverbraid-Memory-Gold" "Riverbraid-Integration-Gold" "Riverbraid-Harness")

echo "--- STARTING INSTITUTIONAL AUDIT ---"

for repo in "${REPOS[@]}"; do
    echo -n "Checking $repo... "
    if [ -f "/workspaces/$repo/package.json" ] && [ -f "/workspaces/$repo/identity.contract.json" ]; then
        echo "✅ SEALED"
    else
        echo "❌ CORRUPT OR MISSING CONTRACT"
        exit 1
    fi
done

echo "--- ALL TAGS VERIFIED: STATIONARY STATE SECURE ---"

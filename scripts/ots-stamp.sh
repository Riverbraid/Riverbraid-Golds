#!/bin/bash
set -e

# Requirement: opentimestamps-client
SEAL="/workspaces/TRUTH.SEAL.sha256"

echo "⏳ Initiating OpenTimestamps sequence..."

# 1. Stamp the file if no .ots exists
if [ ! -f "$SEAL.ots" ]; then
    ots stamp "$SEAL"
    echo "✅ Initial stamp created."
fi

# 2. Attempt to upgrade the proof (CI Mode)
echo "🔍 Checking for proof inclusion in Bitcoin block..."
ots upgrade "$SEAL.ots" || echo "ℹ️ Proof pending block confirmation (this is normal)."

echo "🔒 Timestamping sequence handled."

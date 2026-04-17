#!/bin/bash
# Riverbraid Constellation Health Check
TARGET="de20625f9b8c7d1e8ec84f6d8f86d9f4f2b083a4"
CURRENT=$(cat GLOBAL_STATIONARY_ROOT.seal)

if [ "$CURRENT" == "$TARGET" ]; then
  echo "✅ STATUS: NOMINAL. Constellation is stationary."
  exit 0
else
  echo "❌ STATUS: ALERT. Drift detected in the global seal."
  exit 1
fi

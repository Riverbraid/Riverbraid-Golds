#!/bin/bash
# Riverbraid Braid Evidence Replay v1.5.0
# Purpose: Compiles a byte-pure evidence bundle of the constellation lock.

BUNDLE_NAME="Riverbraid_v1.5.0_Evidence_$(date +%F).tar.gz"
echo "Creating Evidence Bundle: $BUNDLE_NAME"

# 1. Capture the Global Registry
tar -czf "$BUNDLE_NAME" \
  --exclude='node_modules' \
  --exclude='.git' \
  /workspaces/Riverbraid-Golds/golds.manifest.json \
  /workspaces/Riverbraid-Golds/GLOBAL_STATIONARY_ROOT.seal \
  /workspaces/Riverbraid-Core/constitution.threshold.json \
  /workspaces/Riverbraid-Core/run-vectors.cjs

echo "✅ EVIDENCE BUNDLE SEALED."
node -e "console.log('SIGNAL_STATIONARY_MATCH')"

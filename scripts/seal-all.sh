#!/bin/bash
# Riverbraid Gold: State Sealer v1.0
# Generates the TRUTH.md manifest.

echo "--- SEALING SYSTEM STATE ---"
DATE_STAMP=$(date -u +"%Y-%m-%d %H:%M:%S UTC")
MANIFEST="TRUTH.md"

{
  echo "# SYSTEM TRUTH ANCHOR"
  echo "Generated: $DATE_STAMP"
  echo "Status: SEALED"
  echo "---"
  echo "## Core Manifest (SHA-256)"
  find . -maxdepth 2 -not -path '*/.*' -type f -exec sha256sum {} +
  echo "---"
  echo "## Identity Signature"
  cat identity.contract.json
} > "$MANIFEST"

echo "LOG: TRUTH.md generated. System state is now anchored."

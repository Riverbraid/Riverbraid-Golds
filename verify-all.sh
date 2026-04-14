#!/bin/bash
REPOS=(Riverbraid-Core Riverbraid-Golds Riverbraid-Crypto-Gold Riverbraid-Judicial-Gold Riverbraid-Memory-Gold Riverbraid-Integration-Gold Riverbraid-Refusal-Gold Riverbraid-Cognition Riverbraid-Harness-Gold Riverbraid-Temporal-Gold Riverbraid-Action-Gold Riverbraid-Audio-Gold Riverbraid-Vision-Gold Riverbraid-Lite Riverbraid-Interface-Gold Riverbraid-Manifest-Gold Riverbraid-GPG-Gold Riverbraid-Safety-Gold)

echo "=== GLOBAL CONSTELLATION AUDIT ==="
for repo in "${REPOS[@]}"; do
  if [ -d "/workspaces/$repo" ]; then
    cd "/workspaces/$repo"
    if node run-vectors.cjs verify > /dev/null 2>&1; then
      echo "✅ $repo: LOCKED"
    else
      echo "❌ $repo: DRIFT DETECTED"
    fi
    cd /workspaces
  fi
done
echo "=== AUDIT COMPLETE ==="

#!/bin/bash
echo "=== BEGINNING COLD-START CLUSTER AUDIT ==="
ALL_NODES=(Riverbraid-Core Riverbraid-Golds Riverbraid-Crypto-Gold Riverbraid-Judicial-Gold Riverbraid-Memory-Gold Riverbraid-Integration-Gold Riverbraid-Refusal-Gold Riverbraid-Cognition Riverbraid-Harness-Gold Riverbraid-Temporal-Gold Riverbraid-Action-Gold Riverbraid-Audio-Gold Riverbraid-Vision-Gold Riverbraid-Lite Riverbraid-Interface-Gold Riverbraid-Manifest-Gold Riverbraid-GPG-Gold Riverbraid-Safety-Gold Riverbraid-p5 Riverbraid-Hydra Riverbraid-Lang riverbraid-ssg .github)

for repo in "${ALL_NODES[@]}"; do
  if [ -d "/workspaces/$repo" ]; then
    echo -n "Audit $repo: "
    cd "/workspaces/$repo"
    # Execute verification without snapshotting to prove current state
    node run-vectors.cjs verify 2>/dev/null
    if [ $? -eq 0 ]; then
      echo "✅ VERIFIED"
    else
      echo "❌ DRIFT DETECTED"
    fi
  fi
done

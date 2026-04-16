#!/usr/bin/env bash
set -e
echo -e "\033[1;35m🔒 INITIATING GLOBAL SYSTEM SEAL\033[0m"
echo "--------------------------------"
if ! /workspaces/Riverbraid-Golds/verify-all-clean.sh; then
  echo -e "\033[1;31m❌ SEAL ABORTED: System is in Drift.\033[0m"
  exit 1
fi
REPOS=("Riverbraid-Core" "Riverbraid-Golds" "Riverbraid-Crypto-Gold" "Riverbraid-Judicial-Gold" "Riverbraid-Memory-Gold" "Riverbraid-Integration-Gold" "Riverbraid-Refusal-Gold" "Riverbraid-Cognition" "Riverbraid-Harness-Gold" "Riverbraid-Temporal-Gold" "Riverbraid-Action-Gold" "Riverbraid-Audio-Gold" "Riverbraid-Vision-Gold" "Riverbraid-Lite" "Riverbraid-Interface-Gold" "Riverbraid-Manifest-Gold" "Riverbraid-GPG-Gold" "Riverbraid-Safety-Gold")
for repo in "${REPOS[@]}"; do
  echo "→ Anchoring $repo..."
  cd "/workspaces/$repo"
  git add .
  git commit -m "seal: v1.5.0 stationary state" --allow-empty --quiet
  if [ "$repo" != "Riverbraid-Safety-Gold" ]; then
    git push origin main --quiet 2>/dev/null || echo "  ⚠️  $repo: Push skipped"
  fi
  cd /workspaces/Riverbraid-Golds
done
echo -e "--------------------------------\n\033[1;32m💎 SYSTEM SEALED SUCCESSFULLY\033[0m"

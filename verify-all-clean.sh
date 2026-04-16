#!/usr/bin/env bash
set -e
echo -e "\n\033[1;34m🧬 Riverbraid Verification: $(date -u)\033[0m"
echo "------------------------------------------------"
PASS_COUNT=0
FAIL_COUNT=0
REPOS=("Riverbraid-Core" "Riverbraid-Golds" "Riverbraid-Crypto-Gold" "Riverbraid-Judicial-Gold" "Riverbraid-Memory-Gold" "Riverbraid-Integration-Gold" "Riverbraid-Refusal-Gold" "Riverbraid-Cognition" "Riverbraid-Harness-Gold" "Riverbraid-Temporal-Gold" "Riverbraid-Action-Gold" "Riverbraid-Audio-Gold" "Riverbraid-Vision-Gold" "Riverbraid-Lite" "Riverbraid-Interface-Gold" "Riverbraid-Manifest-Gold" "Riverbraid-GPG-Gold" "Riverbraid-Safety-Gold")
for repo in "${REPOS[@]}"; do
  if [ -d "/workspaces/$repo" ]; then
    if (cd "/workspaces/$repo" && sha256sum -c --quiet TRUTH.SEAL 2>/dev/null); then
      printf "  \033[0;32m✔\033[0m %-30s STATIONARY\n" "$repo"
      PASS_COUNT=$((PASS_COUNT+1))
    else
      printf "  \033[0;31m✖\033[0m %-30s DIVERGENT\n" "$repo"
      FAIL_COUNT=$((FAIL_COUNT+1))
    fi
  else
    printf "  \033[0;33m?\033[0m %-30s MISSING\n" "$repo"
  fi
done
echo "------------------------------------------------"
GLOBAL_HASH="4d7eee3a2c8fb11a58a3620bb823317541652be1955726a19b8bd5860682c2b4"
echo -e "Global Anchor: \033[1;36m$GLOBAL_HASH\033[0m"
if [ "$FAIL_COUNT" -eq 0 ]; then
  echo -e "Status: \033[1;32mTOTAL CONVERGENCE ✔\033[0m"
else
  echo -e "Status: \033[1;31mSYSTEM DRIFT ✖ ($FAIL_COUNT divergence detected)\033[0m"
  exit 1
fi

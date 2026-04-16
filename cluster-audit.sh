#!/bin/bash
REPOS=("Riverbraid-Core" "Riverbraid-Golds" "Riverbraid-Crypto-Gold" "Riverbraid-Judicial-Gold" "Riverbraid-Memory-Gold" "Riverbraid-Integration-Gold" "Riverbraid-Refusal-Gold" "Riverbraid-Cognition" "Riverbraid-Harness-Gold" ".github" "Riverbraid-Temporal-Gold" "Riverbraid-Action-Gold" "Riverbraid-Audio-Gold" "Riverbraid-Vision-Gold" "Riverbraid-Lite" "Riverbraid-Interface-Gold" "Riverbraid-Manifest-Gold" "Riverbraid-GPG-Gold" "Riverbraid-Safety-Gold" "Riverbraid-Lang" "Riverbraid-p5" "Riverbraid-Hydra" "riverbraid-ssg")
echo "--- GLOBAL WORKFLOW AUDIT ---"
for repo in "${REPOS[@]}"; do
  echo -n "🔍 $repo: "
  DATA=$(gh run list --repo "Riverbraid/$repo" --limit 1 --json conclusion,name,url 2>/dev/null)
  if [[ -z "$DATA" || "$DATA" == "[]" ]]; then
    echo "⚪ NO RUNS FOUND"
    continue
  fi
  CONCLUSION=$(echo "$DATA" | jq -r '.[0].conclusion')
  if [ "$CONCLUSION" == "success" ]; then echo "✅ PASS"
  elif [ "$CONCLUSION" == "failure" ]; then echo "❌ FAIL -> $(echo "$DATA" | jq -r '.[0].url')"
  else echo "⏳ STATUS: $CONCLUSION"; fi
done

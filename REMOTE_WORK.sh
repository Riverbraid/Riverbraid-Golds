#!/bin/bash
# Riverbraid Gold Cluster: Deferred Remote Finalization
# Use this when high-level PAT or SSH keys are active.

repos=("Riverbraid-Safety-Gold" "Riverbraid-Refusal-Gold")

for repo in "${repos[@]}"; do
  echo "--- Finalizing $repo ---"
  cd /workspaces/$repo
  git remote set-url origin git@github.com:Riverbraid/$repo.git
  git push origin main --no-verify
done

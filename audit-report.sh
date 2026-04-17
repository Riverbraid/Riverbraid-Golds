#!/bin/bash
echo "=== RIVERBRAID CONSTELLATION AUDIT: STATIONARY STATE INVARIANT ==="
echo "Target Root: de20625f9b8c7d1e8ec84f6d8f86d9f4f2b083a4"
echo "------------------------------------------------------------"

for repo in $(ls /workspaces | grep Riverbraid); do
  if [ -f "/workspaces/$repo/run-vectors.cjs" ]; then
    cd "/workspaces/$repo"
    HASH=$(node -e "const fs=require('fs'); const crypto=require('crypto'); console.log(crypto.createHash('sha256').update(fs.readFileSync('run-vectors.cjs')).digest('hex'))")
    echo "$repo Logic Hash: $HASH"
  fi
done

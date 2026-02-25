#!/bin/bash
set -euo pipefail

# Configuration - GPG key established in previous turn
GPG_KEY_ID="D9475D6B717D0E6C8EC84F6D8F86D9F4F2B083A4"

WORKSPACE="/workspaces"
GOLDS_ROOT="/workspaces/Riverbraid-Golds"

echo "🔏 Signing cluster seals with Authority Key $GPG_KEY_ID"

# Function to sign a file if it exists
sign_file() {
    local file="$1"
    if [ -f "$file" ]; then
        # We use --yes to overwrite existing .asc files to ensure stationary state updates
        gpg --yes --detach-sign --armor --local-user "$GPG_KEY_ID" "$file"
        echo "✅ Signed: $(basename "$file")"
    fi
}

# Sign the Root Truth Seal
sign_file "$WORKSPACE/TRUTH.SEAL.sha256"

# Sign the Cluster Manifest (Detached Signature)
sign_file "$GOLDS_ROOT/GOLD_CLUSTER.manifest.json"

echo "🔐 Sealing Sequence Complete."

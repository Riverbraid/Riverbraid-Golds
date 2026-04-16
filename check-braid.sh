#!/bin/bash
echo "--- RIVERBRAID INTEGRITY REPORT ---"
echo "Timestamp: $(date -u)"

# Check Symlinks
[ -L "/workspaces/Riverbraid-Interface-Gold/src/runtime-binding.js" ] && echo "✅ Interface -> Core Link: OK" || echo "❌ Interface -> Core Link: BROKEN"
[ -L "/workspaces/Riverbraid-Golds/core" ] && echo "✅ Global Discovery: OK" || echo "❌ Global Discovery: BROKEN"

# Check GPG Anchor
cd /workspaces/Riverbraid-Interface-Gold
gpg --verify .anchor.asc .anchor > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "✅ GPG Anchor Signature: VALID"
else
    echo "❌ GPG Anchor Signature: INVALID OR MISSING"
fi

# Check Core Validator
node -e "require('/workspaces/Riverbraid-Interface-Gold/src/runtime-binding.js').enforceCoreValidator('sentinel-check')" > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "✅ Runtime Logic Execution: VERIFIED"
else
    echo "❌ Runtime Logic Execution: FAILED (FAIL-CLOSED ACTIVE)"
fi
echo "------------------------------------"

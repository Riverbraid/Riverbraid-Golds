#!/bin/bash
set -e

echo "🧪 STARTING INTEGRITY VALIDATION PROTOCOL..."

# 1. Test Judicial Strictness (ESM Native)
echo "🔍 Testing Judicial Gate..."
cd /workspaces/Riverbraid-Judicial-Gold/src
node --input-type=module -e "import { parse } from './parser.mjs'; try { parse('FAIL'); process.exit(1); } catch(e) { console.log('✅ GATE: Rejected invalid principle'); }"

# 2. Test Physical Anchor
echo "🔍 Testing Physical Anchor..."
cd /workspaces/Riverbraid-Golds
ACTUAL_ROOT=$(./riverbraid-verify.sh | grep "MERKLE_ROOT" | cut -d':' -f2)
EXPECTED_ROOT="de20624134f82d304d694432c31648a2963617df5b241e9496a71e0fecf40ece"

if [ "$ACTUAL_ROOT" == "$EXPECTED_ROOT" ]; then
    echo "✅ PHYSICAL: Merkle Root matches anchor ($EXPECTED_ROOT)"
else
    echo "❌ PHYSICAL: Merkle Root mismatch!"
    exit 1
fi

# 3. Test Authority Signatures
echo "🔍 Testing Authority Signatures..."
gpg --verify /workspaces/Riverbraid-Golds/GOLD_CLUSTER.manifest.json.asc > /dev/null 2>&1
echo "✅ AUTHORITY: Manifest Signature Valid"

gpg --verify /workspaces/TRUTH.SEAL.sha256.asc /workspaces/TRUTH.SEAL.sha256 > /dev/null 2>&1
echo "✅ AUTHORITY: Root Seal Signature Valid"

echo "🌟 STATIONARY STATE VERIFIED."

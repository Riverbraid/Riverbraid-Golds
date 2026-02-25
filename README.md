# Riverbraid Gold Cluster v1.1
## Authority: Michael Tilk <michael.tilk@gmail.com>

This repository serves as the **Sovereign Anchor** for the Riverbraid ecosystem. 
It utilizes a multi-layered verification stack to ensure institutional integrity.

### 1. Verification Chain
1. **Human Layer**: GPG Signature of the `Riverbraid Authority`.
2. **Judicial Layer**: Peggy-parsed `policy.rules` enforcing cluster invariants.
3. **Physical Layer**: SHA-256 Merkle Root of the `Riverbraid-Core` bytes.

### 2. How to Verify Integrity
To verify this cluster from a fresh state:

#### Step A: Verify the Manifest
```bash
gpg --verify GOLD_CLUSTER.manifest.json.asc
gpg --verify /workspaces/TRUTH.SEAL.sha256.asc /workspaces/TRUTH.SEAL.sha256
cd /workspaces/Riverbraid-Golds
STRICT_MODE=1 ./riverbraid-verify.sh
# Export the public key in ASCII armor format
gpg --armor --export michael.tilk@gmail.com > /workspaces/Riverbraid-Golds/PUBLIC_KEY.asc

# Verify the file exists
ls -l /workspaces/Riverbraid-Golds/PUBLIC_KEY.asc
 #!/bin/bash
# riverbraid-verify.sh (V2.0) - Extension-Agnostic
set -euo pipefail

echo "--- STARTING INSTITUTIONAL INTEGRITY AUDIT (V2.0) ---"

# Use identity.contract.json to find the entry point
get_entry_point() {
    local repo_path=$1
    # Extracts the first file from governed_files that contains 'index'
    node -e "const id = JSON.parse(require('fs').readFileSync('$repo_path/identity.contract.json', 'utf8')); console.log(id.governed_files.find(f => f.includes('index')))"
}

# 1. Clean & Preflight (Assuming Harness is now public)
cd /workspaces/Riverbraid-Golds
node ../Riverbraid-Harness-Gold/scripts/clean.js
node ../Riverbraid-Harness-Gold/scripts/preflight.mjs

# 2. Judicial Gate (The Law)
echo "⚖️ Invoking Judicial Gate..."
node packages/judicial-gold/src/verify-judgment.mjs

# 3. Dynamic Invariant Check (Gate 6 Rewrite)
for repo in ../Riverbraid-*; do
    if [ -d "$repo" ]; then
        ENTRY=$(get_entry_point "$repo")
        echo "🔍 Auditing $repo via $ENTRY"
        # Check for @linear/@nonlinear tags in the dynamically discovered file
        if ! grep -qE "@linear|@nonlinear" "$repo/$ENTRY"; then
            echo "FATAL:MISSING_INVARIANT_TAG in $repo/$ENTRY"
            exit 1
        fi
    fi
done

echo "✅ Audit Complete. No symbolic links required."
# Run this for each petal (Core, Crypto, etc.)
# It adds the test script and pins the engine
tmp=$(mktemp)
jq '.scripts.test = "node verify.mjs" | .engines.node = ">=20.11.0"' package.json > "$tmp" && mv "$tmp" package.json
# Consolidate and purge the old overlaps
node scripts/generate-cluster-manifest.mjs
rm INTEGRITY_MANIFEST.json STATIONARY_MANIFEST.json
# 1. Final verification of the Clearsigned Manifest
gpg --verify /workspaces/Riverbraid-Golds/GOLD_CLUSTER.manifest.json.asc

# 2. Final check of the Detached Seal for the Root
gpg --verify /workspaces/TRUTH.SEAL.sha256.asc /workspaces/TRUTH.SEAL.sha256
# Riverbraid Governance Protocol (V1.1)
**Principle: Coherence Over Volume | Baseline: Mechanical Honesty**

## 1. The Prime Directive
Any state change within the Riverbraid cluster must be gated by a **Judicial Pass**. If the code functions but the policy fails, the system is in a "Distorted State" and must be halted (Fail-Closed).

## 2. Handling Distortions (The Recovery Path)
A distortion is defined as any mismatch between the **Physical Bytes** (SHA-256) and the **Judicial Policy** (Peggy Grammar).

### Step A: Detection
Distortions found during the `riverbraid-verify.sh` audit trigger an immediate exit code `1`. No further builds or seals are permitted.

### Step B: The Honest Advisor Mirror
Upon detection, the Authority (Maintainer) must:
1. Identify if the distortion is **Structural** (file paths/extensions) or **Semantic** (logic/invariants).
2. If structural: Update the `identity.contract.json` to reflect the new reality.
3. If semantic: Roll back to the last known **Stationary State** (verified by GPG signature).

### Step C: Re-Sealing
A new `TRUTH.SEAL` may only be generated if:
- All seven petals return `PASS:{PETAL}_INVARIANTS`.
- The `GOLD_CLUSTER.manifest.json` is regenerated.
- The Authority clearsigns the manifest with the Master GPG Key (`D9475D6B717D0E6C8EC84F6D8F86D9F4F2B083A4`).

## 3. Key Rotation & Authority
The GPG Key is the "Human Anchor."
- **Master Key**: Used for signing the Cluster Seal.
- **Revocation**: If the Master Key is compromised, the `identity.contract.json` in `Riverbraid-Golds` must be updated with a new `expected_signer_fingerprint`.

## 4. Invariant Stationary State
The following items are "Locked" and require a Judicial Amendment to change:
- **Encoding**: Must remain UTF-8/ASCII.
- **Dependencies**: Zero runtime dependencies in Core/Golds.
- **Time**: All system operations must be anchored in UTC.
# 1. Update the Manifest script to include the Authority Fingerprint
sudo sed -i '/manifest = {/a \  authority: "D9475D6B717D0E6C8EC84F6D8F86D9F4F2B083A4",' /workspaces/Riverbraid-Golds/scripts/generate-cluster-manifest.mjs

# 2. Regenerate and Re-sign
node /workspaces/Riverbraid-Golds/scripts/generate-cluster-manifest.mjs
gpg --clearsign --local-user michael.tilk@gmail.com --output /workspaces/Riverbraid-Golds/GOLD_CLUSTER.manifest.json.asc /workspaces/Riverbraid-Golds/GOLD_CLUSTER.manifest.json
if (pkg.dependencies && Object.keys(pkg.dependencies).length > 0) {
  fatal('Core must have zero dependencies');
}
# Ensure directory exists
mkdir -p /workspaces/Riverbraid-Crypto-Gold/vectors/

# Write the vector set
sudo tee /workspaces/Riverbraid-Crypto-Gold/vectors/sha256-test.json > /dev/null << 'EOF'
[
  {
    "description": "Empty string",
    "input": "",
    "expected": "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"
  },
  {
    "description": "The word 'Riverbraid'",
    "input": "Riverbraid",
    "expected": "d09f61b3695279326d97e7436b772099308e7f1a3075c3f912e75e9b7201b1a7"
  }
]

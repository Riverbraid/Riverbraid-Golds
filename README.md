# Riverbraid Golds
****Authority Hub and Cluster Manifest
This repository serves as the central specification and truth anchor for the Riverbraid Gold Cluster.

# McLean (2026) Primary Coherence Anchor

### Verification
Execute the deterministic invariant check:
```bash
npm test
cd /workspaces/Riverbraid-Judicial-Gold

# 1. Purge node_modules and update ignore
rm -rf node_modules/
echo "node_modules/" >> .gitignore
git rm -r --cached node_modules/ 2>/dev/null || true

# 2. Inject Full MIT License
export FULL_MIT="Copyright 2026 Riverbraid Sovereignty Protocol

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the \"Software\"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE."
echo -e "$FULL_MIT" > LICENSE

# 3. Standardize identity.contract.json
cat << 'EOF' > identity.contract.json
{
  "name": "riverbraid-judicial-gold",
  "version": "1.1.0",
  "governed_files": [
    "README.md",
    "package.json",
    "identity.contract.json",
    "LICENSE",
    "grammar.pegjs",
    "policy.rules"
  ],
  "invariants": {
    "entropy_ban": true,
    "deterministic_output": true
  }
}

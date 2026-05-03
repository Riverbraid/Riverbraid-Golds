# Riverbraid-Golds: Root Audit & Integrity Floor

**STATUS:** REDUCED_FLOOR_PARTIALLY_FUNCTIONAL  
**CLAIM_BOUNDARY:** Reduced Canonical Floor Only

## Current Verification Scope
This repository currently manages a reduced canonical verification floor. The root audit verifies the following repositories under declared smoke-check conditions:

1. Riverbraid-Core
2. Riverbraid-Wasm-Bridge
3. Riverbraid-Manifest-Gold
4. Riverbraid-Golds
5. Riverbraid-Lang

**Note:** This does not claim that all public Riverbraid repositories are active or fully verified. Broader constellation functionality is not yet claimed.

## Usage
To run the root audit:
`powershell
node audit-constellation.cjs
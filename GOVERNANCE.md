# Riverbraid Governance Protocol
**Principle: Coherence Over Volume | Baseline: Mechanical Honesty**

## 1. The Judicial Gate
All state changes must pass the `Riverbraid-Judicial-Gold` parser. 
- **Rule**: Policy Violation = Fail-Closed.
- **Rule**: Non-ASCII characters in Core = Fail-Closed.

## 2. Handling Distortions
If `check-integrity.sh` returns a failure:
1. **Identify**: Is it a Physical mismatch (Merkle) or Authority mismatch (GPG)?
2. **Revert**: Roll back to the last signed commit in `Riverbraid-Golds`.
3. **Audit**: Use `STRICT_MODE=1 ./riverbraid-verify.sh` to find the source of entropy.

## 3. Sealing Procedure
A new state is only "Gold" when:
1. `riverbraid-verify.sh` passes.
2. `GOLD_CLUSTER.manifest.json` is regenerated.
3. The Authority clearsigns the manifest and root seal.

## 4. GPG Key Rotation & Emergency Protocol
**Current Master Fingerprint**: `D9475D6B717D0E6C8EC84F6D8F86D9F4F2B083A4`

### 4.1. Scheduled Rotation
- The Master Key should be rotated every 24 months.
- A "Transition Manifest" must be signed by both the old and new keys to maintain the chain of trust.

### 4.2. Compromise (Emergency)
1. Publish the Revocation Certificate immediately.
2. Update the `authority` field in `scripts/generate-cluster-manifest.mjs`.
3. Re-sign the entire cluster with the new Emergency Anchor.

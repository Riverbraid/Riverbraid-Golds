# Riverbraid Gold Cluster Architecture

The Riverbraid Gold Cluster is a sovereign, closed-loop intelligence architecture. It scales in **coherence**, not in raw compute.

## 1. System Topology (Hub & Petal)

- **Hub (Riverbraid-Golds):** The central root of trust. Holds the `CLUSTER.SEAL.sha256` and the master OID manifest.
- **Core (Riverbraid-Core):** The reference standard for governance and deterministic logic.
- **Petals:** Domain-specific logic units (Crypto, Judicial, Memory, Integration).
- **Harness:** The executable orchestrator for cluster-wide integrity audits.

## 2. The Verification Loop
Invariants are enforced through a recursive verification gate:
1. **Physical:** `riverbraid-verify.sh` checks byte-identity (Stationary State).
2. **Logical:** `validate-rules.mjs` checks the Fail-Closed blockade.
3. **Semantic:** `Identity Contracts` check alignment with Riverbraid principles.

## 3. Signal Lexicon
- **MECHANICAL_HONESTY (Crypto):** Mathematical proof of state.
- **LEAST_ENTROPY (Judicial):** Fail-closed blockade logic.
- **MEANING_CENTRIC (Memory):** Thermodynamic threshold for persistence.
- **SEMANTIC_BRIDGE (Integration):** Translation between Source and Action.

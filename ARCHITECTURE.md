# Riverbraid Gold Cluster – Architecture Specification
**Version:** 1.2 (Institutional Complete)  
**Status:** Governance-Locked Reference Standard  

## 1. System Topology
The cluster follows a **Hub and Petal** formation. The Hub (Golds) manages the identity and verification of specialized logic units (Petals).

## 2. Boot & Verification Sequence
The system enforces stationarity through a recursive verification chain:



1. **Harness**: Entry point. Checks ASCII-7 compliance and entropy (audit-all.sh).
2. **Golds (Hub)**: Cryptographic manifest verification (`CLUSTER.SEAL.sha256`).
3. **Core**: Deterministic governance constants and Frozen Core logic.
4. **Petals**: Domain-specific invariant enforcement (Signals).

## 3. Signal Lexicon
- **MECHANICAL_HONESTY (Crypto)**: Mathematical proof of state.
- **LEAST_ENTROPY (Judicial)**: Fail-closed blockade logic.
- **MEANING_CENTRIC (Memory)**: Thermodynamic threshold for persistence.
- **SEMANTIC_BRIDGE (Integration)**: Abstract-to-Concrete translation.

## 4. Invariant: Fail-Closed
Any breach of a signal results in an immediate halt. No partial state is ever emitted.

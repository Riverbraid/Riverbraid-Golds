# Riverbraid Gold Cluster Architecture

The Riverbraid Gold Cluster is a sovereign, closed-loop intelligence architecture. 

## 1. Topology (Hub & Petals)
- **Hub (Golds):** Root of trust; manages `CLUSTER.SEAL.sha256`.
- **Core:** Reference standard for governance.
- **Petals:** Specialized logic (Crypto, Judicial, Memory, Integration).
- **Harness:** Executable orchestrator for audits (`audit-all.sh`).

## 2. Invariants
- **Mechanical Honesty:** Fail-closed on invariant breach.
- **Stationary State:** Byte-identical truth (No wall-clocks).
- **Scale Separation:** Rules decoupled from entropy.

## 3. Verification
Run `./riverbraid-verify.sh` to validate the OID manifest against the Cluster Seal.

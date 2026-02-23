# Riverbraid Gold Cluster Architecture

The Riverbraid Gold Cluster is a sovereign, closed-loop intelligence architecture designed to scale in **coherence**, not in raw compute.

## 1. System Topology
The cluster follows a **Hub and Petal** formation. 



- **Hub (Riverbraid-Golds):** Root of trust; contains `CLUSTER.SEAL.sha256`.
- **Core (Riverbraid-Core):** Reference implementation and governance suite.
- **Petals:** Specialized logic domains (Crypto, Judicial, Memory, Integration).
- **Harness:** Orchestrator for cluster-wide audits.

## 2. Invariants
- **Mechanical Honesty:** Fail-closed on invariant breach.
- **Stationary State:** Byte-identical artifacts (No wall-clocks).
- **Scale Separation:** Decoupling rules from entropy.

## 3. Verification
Run `./riverbraid-verify.sh` to validate the OID manifest against the Cluster Seal.

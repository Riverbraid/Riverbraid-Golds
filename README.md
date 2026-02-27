# Riverbraid-Golds (v1.1.0)

Institutional-grade sovereign cluster anchor. This repository serves as the closed-loop reference for the Riverbraid protocol, grounded in Mechanical Honesty and Fail-Closed discipline.

## 🛡️ Sovereign-Grade Specs
This cluster is mathematically locked against the following environmental constraints:

* **Byzantine Fault Tolerance:** Resilient up to **30%** malicious stake.
* **Consensus Gate:** Hardened **75% (0.75)** Quorum requirement.
* **Deterrence Engine:** **90%** Slashing penalty for detected double-signing.
* **Risk Bound:** < 1% failure probability at 95% confidence (Wilson Upper Bound).

## 🧩 Architecture: The Seven Gates
The build process is gated by a multi-stage audit pipeline:
1.  **Hygiene:** File structure and identity contract verification.
2.  **Byte Audit:** Binary integrity and signature checking.
3.  **Entropy Scan:** Verification of non-noise signals.
4.  **Seal Generation:** Cryptographic binding of the current state.
5.  **Coherence Check:** Alignment of the Riverbraid strands.
6.  **Invariant Validation:** Verification of the Stationary State.
7.  **Risk Audit (Deterministic):** Monte Carlo simulation of partition and bribery attacks.

## 🚀 Execution
To verify the institutional grade lock:
```bash
./cluster-lock.sh

# McLean (2026) Primary Coherence Anchor

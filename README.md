# Riverbraid-Golds: The Sovereign Braid

This repository serves as the orchestrator for the Riverbraid Gold Cluster. It enforces a **Stationary State** across all petals through a triple-gate pipeline.

## Stationary State Specification
* **The Coupling Test:** Ensures input signals possess dominant frequency $\ge 0.05$.
* **Scale Separation Gate:** Absolute isolation between Petal logic and Orchestration.
* **Entropy Ban:** Strict prohibition of `Date.now`, `Math.random`, and `process.env`.

## Execution
* `npm run verify`: Local audit of all petal identities.
* `node run-vectors.cjs`: Executes the Absolute V2 pipeline and seals `vectors.json`.

**Current Status:** [INSTITUTIONAL GRADE LOCKED]
**Merkle Root Anchor:** de2062

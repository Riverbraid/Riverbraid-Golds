# Riverbraid-Golds

**Version:** 1.1  
**Pipeline Standard:** Absolute V2 (Refined)  
**Language:** Python ≥ 3.10  
**Status:** Active — Cluster Orchestrator

-----

## What It Is

Riverbraid-Golds is the **cluster manifest and pipeline orchestrator** for the Riverbraid Gold Cluster. It coordinates all Gold petals through a four-stage deterministic pipeline and exports validated predicate logic for deployment.

It does not contain intelligence, policy, or adaptive logic. It is the structural layer that ensures all petals are present, anchored, and stationary before the system is considered ready.

-----

## What It Is Not

- Not a framework or application runtime
- Not a policy engine
- Not a standalone tool — it requires all petals to be present as submodules

-----

## The Absolute V2 Pipeline

The cluster operates through a single linear gate. Each stage must pass before the next begins. Any failure halts the pipeline and returns `FAIL-CLOSED`.

**Stage 1 — Hygiene**  
Scans all petals for presence, verify scripts, and non-empty protocol definitions. Rejects any petal that fails structural inspection.

**Stage 2 — Assemble**  
Runs `verify.py` for each petal. Confirms all petals report `STATIONARY`. Any petal with detected drift halts the pipeline.

**Stage 3 — Build**  
Computes a cluster-level hash from all petal anchor hashes. Validates thermodynamic signal integrity across the braid.

**Stage 4 — Vectors**  
Exports `vectors.json` — the validated predicate state of the cluster — for use by downstream systems.

-----

## Usage

```bash
# Clone with all petals
git clone --recursive https://github.com/Riverbraid/Riverbraid-Golds.git

# Run the full Absolute V2 Pipeline
python build.py

# Verify local stationary state
python braid_sync.py
```

-----

## Invariant Contract

Every petal in this cluster exposes a `verify.py` script. If a petal’s internal state has drifted from its mathematical anchor, the system enters a `FAIL-CLOSED` state and halts. There is no partial execution.

The `[Signal: ... | Braid: CLOSED-LOOP]` output from each verify script is the confirmation that the invariant holds.

-----

# Riverbraid — Complete Repository Index

Drop this table into every README to replace the existing navigation table.
The section heading can be “Full Repository Index” or “Riverbraid Repositories” — your choice.

-----

## Full Repository Index

|Repository                                                                              |Signal                   |Purpose                                      |
|----------------------------------------------------------------------------------------|-------------------------|---------------------------------------------|
|[.github](https://github.com/Riverbraid/.github)                                        |—                        |Organization profile                         |
|[Riverbraid-Core](https://github.com/Riverbraid/Riverbraid-Core)                        |Root                     |Capacity control substrate                   |
|[Riverbraid-Golds](https://github.com/Riverbraid/Riverbraid-Golds)                      |—                        |Cluster manifest and pipeline orchestration  |
|[Riverbraid-Cognition](https://github.com/Riverbraid/Riverbraid-Cognition)              |Aperture                 |Meaning-processing and cognitive architecture|
|[Riverbraid-Crypto-Gold](https://github.com/Riverbraid/Riverbraid-Crypto-Gold)          |`MECHANICAL_HONESTY`     |SHA-256 state anchoring                      |
|[Riverbraid-Judicial-Gold](https://github.com/Riverbraid/Riverbraid-Judicial-Gold)      |`LEAST_ENTROPY`          |Fail-closed predicate governance             |
|[Riverbraid-Refusal-Gold](https://github.com/Riverbraid/Riverbraid-Refusal-Gold)        |`BOUNDARY_LOGIC`         |Deterministic boundary enforcement           |
|[Riverbraid-Memory-Gold](https://github.com/Riverbraid/Riverbraid-Memory-Gold)          |`MEANING_CENTRIC`        |Meaning-centric persistence                  |
|[Riverbraid-Integration-Gold](https://github.com/Riverbraid/Riverbraid-Integration-Gold)|`SEMANTIC_BRIDGE`        |Mode enactment                               |
|[Riverbraid-Safety-Gold](https://github.com/Riverbraid/Riverbraid-Safety-Gold)          |`ENTROPY_SCAN`           |Protocol integrity and entropy scanning      |
|[Riverbraid-Harness-Gold](https://github.com/Riverbraid/Riverbraid-Harness-Gold)        |`STATIONARY_STATE_ACTIVE`|Fail-closed cluster verification harness     |
-----

## Design Properties

- **Deterministic** — pipeline output is fully predictable given the same petal states
- **Fail-closed** — the system halts rather than allowing unverified state to propagate
- **Governance-first** — no stage is bypassed; no partial execution is permitted
- **Auditable** — every stage produces a structured output that can be inspected independently

-----
## McLean (2026) Primary Coherence Anchor
This repository operates under the σ (sigma) stationary precedent. Meaning is the Internal Frequency of a system successfully navigating environmental entropy.

---
*Anchored in McLean (2026) Primary Coherence + σ stationary precedent.*
lds/blob/main/ARCHITECTURE.md).

## Contributing

See `CONTRIBUTING.md`.

-----

## License

See `LICENSE`.

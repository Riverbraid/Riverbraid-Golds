# Implement Riverbraid-Golds registry scaffold without claim inflation

## Purpose

Use the supplied Riverbraid-Golds implementation packet as a source seed for a bounded registry scaffold.

This issue should not be treated as a claim that Riverbraid-Golds is functional, production-ready, externally audited, or security-complete.

## Scope

Implement Riverbraid-Golds as a registry and coordination surface for Gold repositories, including:

- Gold metadata registry.
- Lifecycle statuses: `experimental`, `functional`, `production-ready`, `deprecated`.
- Evidence gates for status promotion.
- Expansion-gate handling with default active-entry limit of 30 unless approved exception exists.
- Succession procedures for registry continuity.
- Claim and evidence ledgers that reflect actual verification records.
- Reviewer-facing status surfaces.

## Implementation order

1. Complete live repository inventory and compatibility check.
2. Add documentation scaffold and normalized ledgers.
3. Add minimal source modules only after API normalization.
4. Add tests that match the chosen API.
5. Record execution output before making any pass claim.
6. Add package/build tooling only if it preserves existing verifier behavior.
7. Add workflow changes only after separate explicit approval.

## Coherence corrections required before code implementation

- Preserve the current non-claim boundary.
- Do not mark the repository Functional until evidence supports it.
- Do not claim exact Gold counts without active registry evidence.
- Do not add pass/fail ledger rows without real evidence records.
- Do not describe placeholder signing as production cryptographic assurance.
- Do not overwrite current verifier scripts without a migration path.
- Do not mutate workflow files in the initial implementation pass.

## Acceptance criteria for the first implementation PR

- Existing Riverbraid verifier scripts remain intact.
- Minimal registry API is added and tested.
- Tests pass locally before any status upgrade.
- Ledgers remain pending/proposed unless backed by actual records.
- No workflow, release, tag, registry pin, or repository-settings mutation is included.
- Placeholder mechanisms are clearly labeled as placeholders.

## Linked plan

See `docs/RIVERBRAID_GOLDS_IMPLEMENTATION_PLAN.md`.

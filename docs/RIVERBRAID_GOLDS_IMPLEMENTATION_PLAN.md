# Riverbraid-Golds Implementation Plan

**Status:** implementation proposal only
**Last updated:** 2026-06-14

This file records the implementation direction for Riverbraid-Golds as a registry and coordination surface for Riverbraid Gold repositories.

It is not a functional-status claim. It does not claim certification, production readiness, external audit, legal approval, absolute security, or absence of defects.

## Purpose

Riverbraid-Golds should eventually provide:

- Gold repository metadata registry.
- Lifecycle tracking: `experimental`, `functional`, `production-ready`, and `deprecated`.
- Evidence gates for lifecycle promotion.
- Expansion-gate handling, with a default active-entry limit of 30 unless an approved exception exists.
- Succession procedures for registry continuity.
- Claim and evidence ledgers tied to actual verification records.
- Read-only status reporting for reviewers.

## Normalization rules

The source packet is useful, but it should be normalized before implementation:

1. Do not mark the repository Functional until execution evidence supports that status.
2. Do not claim exact Gold counts unless they are sourced from the active registry.
3. Do not create pass or fail ledger entries without real evidence records.
4. Do not represent placeholder signing as production cryptographic assurance.
5. Do not overwrite current verifier scripts without a compatibility plan.
6. Do not modify workflow files in this implementation pass.
7. Keep all status language bounded and evidence-backed.

## Implementation phases

### Phase 0: inventory and compatibility

- Inventory the current repository files and package scripts.
- Confirm current verifier paths remain valid.
- Decide whether Riverbraid-Golds remains primarily a constellation authority repository or becomes a package-style registry module.

Exit gate: no existing verifier path is broken.

### Phase 1: documentation scaffold

Candidate files:

- `docs/REGISTRY_POLICY.md`
- `docs/SUCCESSION_RULES.md`
- `docs/EXPANSION_GATE.md`
- `docs/GOVERNANCE.md`
- `docs/templates/CLAIM_EVIDENCE_RECORD.md`
- `KNOWN_LIMITATIONS.md`
- `CLAIM_LEDGER.md`
- `EVIDENCE_LEDGER.md`

Ledger rule: entries begin as `pending`, `proposed`, or `not yet evidenced` unless backed by actual logs or records.

### Phase 2: core source scaffold

Candidate files:

- `src/errors/CoreError.js`
- `src/registry/GoldRegistry.js`
- `src/registry/ExpansionGate.js`
- `src/registry/SuccessionRules.js`
- `src/index.js`
- `src/types.d.ts`

Required fixes before code commit:

- Pick one public API naming convention.
- Add event support if `src/index.js` listens for registry events.
- Align methods expected by tests with methods implemented in source.
- Validate IDs, repository URLs, maintainers, lifecycle status, dependencies, and evidence references consistently.
- Keep signing behavior test-only until real signing is implemented and evidenced.

### Phase 3: tests and execution evidence

Candidate files:

- `test/setup.js`
- `test/registry/gold-registry.test.js`
- `test/registry/expansion-gate.test.js`
- `test/registry/succession-rules.test.js`
- `test/core-error.test.js`
- `test/golds-module.test.js`

Exit gate:

- `npm test` passes.
- Lint passes or rules are adjusted to realistic project constraints.
- Output is recorded before any pass claim is made.

### Phase 4: package and build tooling

Candidate files:

- `package.json`
- `jest.config.js`
- `build.js`
- `.nvmrc`
- `.editorconfig`
- `.prettierrc`
- `.eslintrc.js`
- `.gitignore`
- `.gitleaks.toml`

Required fixes:

- Preserve current Riverbraid scripts unless a migration plan replaces them.
- Avoid contradictory package names or maturity versions.
- Ensure build scripts reference variables in scope.
- Separate generated registry data from tracked source files.

### Phase 5: governance and reviewer surfaces

Candidate files:

- `SECURITY.md`
- `CONTRIBUTING.md`
- `CODE_OF_CONDUCT.md`
- `LICENSE`
- `.github/CODEOWNERS`
- `.github/dependabot.yml`
- `.github/ISSUE_TEMPLATE/bug_report.md`
- `.github/ISSUE_TEMPLATE/feature_request.md`
- `.github/PULL_REQUEST_TEMPLATE.md`

Rule: distinguish implemented controls, planned controls, and manual repository settings.

### Phase 6: workflows only after explicit approval

Candidate workflow files:

- `.github/workflows/ci.yml`
- `.github/workflows/security.yml`
- `.github/workflows/codeql.yml`
- `.github/workflows/quality-gates.yml`
- `.github/workflows/release.yml`

Workflow changes are execution-surface changes and require a separate approval gate.

## First implementation PR acceptance criteria

- Existing Riverbraid verifier scripts remain intact.
- Minimal registry API is added and tested.
- Lifecycle status remains `experimental` unless evidence supports promotion.
- Ledgers do not contain invented pass/fail evidence.
- Workflows, releases, tags, registry pins, and repository settings are not changed in the first PR.
- Placeholder mechanisms are clearly labeled as placeholders.

## Recommended next issue title

`Implement Riverbraid-Golds registry scaffold without claim inflation`

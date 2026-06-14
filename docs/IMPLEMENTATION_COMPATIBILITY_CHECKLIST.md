# Riverbraid-Golds Implementation Compatibility Checklist

**Status:** planning checklist
**Last updated:** 2026-06-14

This checklist keeps the Riverbraid-Golds implementation work bounded, reversible, and evidence-gated.

It does not claim that the registry scaffold is implemented, tested, functional, production-ready, externally audited, or security-complete.

## Current preservation boundary

Before implementation begins, preserve the current repository role and existing verifier behavior:

- `README.md` currently frames Riverbraid-Golds as a constellation-level coordination and registry surface.
- `package.json` currently contains Riverbraid verifier scripts.
- Existing verifier scripts such as `verify-feature-flow.cjs` and `audit-constellation.cjs` must not be overwritten without a migration plan.
- Any future package-style registry implementation must coexist with the current Riverbraid verification surface until replacement is evidenced.

## Pre-implementation checklist

- [ ] Inventory current root files.
- [ ] Inventory current package scripts.
- [ ] Inventory current verifier scripts.
- [ ] Identify any Evaluation Kit registry reference to this repository.
- [ ] Confirm whether new source files should be additive or replace an existing path.
- [ ] Confirm whether generated registry data should be tracked or ignored.
- [ ] Decide package name and maturity version before changing `package.json`.
- [ ] Decide one public API convention before adding tests.

## Source-code readiness checklist

Before adding `src/` files:

- [ ] Choose one API style: `initialize/add/get/update/remove` or `init/addGold/getGold/updateGold/removeGold`.
- [ ] Confirm whether `GoldRegistry` needs event support.
- [ ] Define lifecycle statuses exactly once.
- [ ] Define expansion-gate states exactly once.
- [ ] Define succession status values exactly once.
- [ ] Define a consistent Gold ID format.
- [ ] Define whether repository URLs are required and how they are validated.
- [ ] Define evidence-reference requirements.
- [ ] Define dependency-reference requirements.
- [ ] Define how deprecation differs from removal.

## Test readiness checklist

Before adding or committing tests:

- [ ] Tests match the chosen API.
- [ ] Tests do not rely on fake ledger pass states.
- [ ] Tests use safe temporary directories.
- [ ] Tests do not delete tracked data.
- [ ] Jest configuration matches installed dependencies.
- [ ] Coverage thresholds are realistic for the current scaffold stage.
- [ ] Existing Riverbraid verification scripts still run.

## Ledger readiness checklist

Before adding claim or evidence ledgers:

- [ ] Every `pass` entry has a source record.
- [ ] Every `fail` entry has a source record.
- [ ] Every `pending` entry is clearly not a claim.
- [ ] No fabricated timestamps are used.
- [ ] No fabricated validators are used.
- [ ] CER links point to existing files or are marked pending.

## Security readiness checklist

Before adding security claims or security configuration:

- [ ] Security controls are separated into implemented, planned, and manual.
- [ ] Security contact details are real or marked TBD.
- [ ] No private keys, tokens, or secrets are included.
- [ ] Placeholder signing is labeled test-only.
- [ ] Dependency audit output exists before vulnerability claims are made.
- [ ] GitHub repository settings are not claimed unless verified.

## Workflow and release gate

Workflow and release changes are explicitly outside the first implementation pass.

Do not add or modify:

- `.github/workflows/*`
- release workflows
- tag/release policy
- registry pins
- publication settings
- secrets or keys

until a separate approval and review step is completed.

## First safe implementation boundary

The first code implementation should be limited to:

- Minimal source scaffold.
- Matching unit tests.
- Honest pending ledgers.
- Documentation updates.
- Compatibility preservation.

It should not include workflow, release, tag, registry-pin, or repository-setting changes.

## Stop conditions

Pause implementation if any of the following appear:

- A change would overwrite an existing verifier path.
- A change would require a secret or signing key.
- A change would imply production readiness.
- A change would create pass/fail evidence without source logs.
- A workflow or release mutation becomes necessary.
- Tests and source disagree on the public API.

## Next safe action

Use issue #5 as the tracker for the implementation scaffold, then proceed with a small documentation-first PR or direct doc-only commits before code mutation.

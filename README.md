# Riverbraid-Golds

Riverbraid-Golds coordinates constellation-level repository classification, registry relationships, and verification surfaces for Riverbraid.

Riverbraid is an open-source deterministic integrity floor for AI governance. It is designed to make structure, authority, and drift visible before trust is granted.

## Role in Riverbraid

Riverbraid-Golds is a canonical constellation coordination surface within Riverbraid.

## Public verification boundary

This repository is part of the current Evaluation Kit pinned verification registry and supports repository role, registry-relationship, verification-path, and audit-surface coordination.

Registry membership does not establish equal verification depth, registry freshness, F3/F4 functional-core membership, or account-wide operation.

## Public repository classification

`PUBLIC-REPOSITORY-CLASSIFICATION.json` is the current machine-readable classification of all 52 public repositories visible under the `Riverbraid` GitHub user account as of 2026-07-27.

It keeps these dimensions separate:

- role classification;
- lifecycle status;
- Evaluation Kit registry membership;
- registry verification depth;
- F3/F4 functional-core membership.

The classification does not make all 52 repositories verified or operational. It does not change registry pins and does not pre-adopt an F3/F4 functional core.

## Classification validation

`validate-public-classification.mjs` checks that:

- all declared role categories exist, including empty `SUPERSEDED` and `ARCHIVED` categories;
- role, lifecycle, and verification-depth dimensions each contain exactly 52 unique repositories;
- all three dimensions contain the same repository set;
- F3/F4 functional-core membership remains `NOT_ASSESSED_FOR_F3_F4`;
- the environment-policy vocabulary and current account-wide status remain internally coherent.

Run:

```bash
npm run verify:classification
```

A successful validator result establishes internal structural consistency of these classification records only. It does not verify the behavior, currency, security, or operational status of all repositories.

## Environment-floor relationship

`ENVIRONMENT-FLOOR-RELATIONSHIP-POLICY.json` defines the bounded vocabulary every repository should use when declaring whether it is pinned to the Evaluation Kit environment, compatible under a declared range, outside the pinned floor, not yet assessed, or blocked by an unresolved environment condition.

The current account-wide relationship remains `NOT_ASSESSED`. The policy does not imply that all repositories use the Evaluation Kit lock, and it preserves the current Docker-digest limitation.

## Evidence boundary

This repository does not claim certification, legal approval, production readiness, absolute security, external audit, complete AI safety, adoption, or absence of defects.

## Role

Riverbraid-Golds supports the broader Riverbraid governance floor by organizing how repository roles, registry relationships, verification paths, and audit surfaces relate to one another.

It provides:

- constellation orientation;
- public-repository role and lifecycle classification;
- environment-floor relationship policy;
- registry-surface coordination;
- verification-path references;
- cross-repository role clarity;
- audit-surface organization.

## Relationship to the Evaluation Kit

The preferred public starting point for outside evaluators is:

```text
Riverbraid-Evaluation-Kit
```

The Evaluation Kit provides the public 30-repository pinned registry and evaluation path.

Riverbraid-Golds supports constellation-level coherence. It does not replace the Evaluation Kit as the public entry point.

## Verification

Use the verification command declared for this repository in the active pinned registry and preserve its declared verification-depth boundary.

## Evidence boundary

This repository provides coordination and classification surfaces.

It does not claim third-party certification, legal approval, production readiness, absolute security, absence of defects, external audit, complete AI safety, registry freshness, independent reproduction, or full-constellation operation.

## License

MIT

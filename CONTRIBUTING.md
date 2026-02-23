# Contributing to Riverbraid Gold

The Riverbraid system operates under the principle of **Coherence over Volume**. 

## The "Golden Rule" of Contribution
Every pull request must pass the `riverbraid-verify.sh` suite. If a change increases entropy (non-determinism) or violates the ASCII floor, it will be rejected.

## Development Workflow
1. **Branching**: Use feature branches.
2. **Deterministic Code**: Use only pure functions. No `Date`, `Math.random`, or external I/O without a semantic bridge.
3. **ASCII Only**: No Unicode in code or comments. Use \u escapes if strictly necessary for testing.
4. **Tests**: Every new function requires a `.test.js` file in the `tests/` directory.

## Submission Checklist
- [ ] Code passes `npm test`
- [ ] Code passes `node scripts/entropy-check.mjs`
- [ ] identity.contract.json is updated
- [ ] Documentation reflects API changes
